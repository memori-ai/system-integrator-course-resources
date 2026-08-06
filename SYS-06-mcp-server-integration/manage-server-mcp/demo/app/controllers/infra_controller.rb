# Infra Controller - One-click demo infrastructure
#
# Backs the "Start demo" button on the demo pages: starts the ngrok tunnel
# container needed by the requested demo (stopping the tunnels of the other
# demos first, since free ngrok accounts allow a single active agent), then
# reads the public URL from the ngrok agent API and returns it ready to be
# pasted into AIsuru.
#
# Docker access happens through the docker CLI pointed at the socket proxy
# (DOCKER_HOST, see docker-compose.yml), which only exposes the container
# start/stop APIs.
#
# SECURITY: only the hardcoded service names below are ever passed to
# docker compose, always as an argument array (no shell). User input never
# reaches a command line.

require "open3"
require "net/http"

class InfraController < ApplicationController
  # Each demo maps to the ngrok container the "Start demo" button launches.
  TUNNELS = {
    "demo1" => { service: "ngrok-mongo", builder: :mongo_sections },
    "demo2" => { service: "ngrok-demo2", builder: :mysql_sections },
    "demo3" => { service: "ngrok-mcp",   builder: :mcp_sections },
  }.freeze
  ALL_SERVICES = TUNNELS.values.map { |t| t[:service] }.uniq.freeze

  # ngrok authtokens are opaque strings; this pattern is deliberately strict so
  # that nothing a user pastes can inject extra lines into .env.
  TOKEN_FORMAT = /\A[A-Za-z0-9_\-]{20,200}\z/

  # start-all.js writes this placeholder when demo/.env is missing, so it must
  # count as "no token" and still trigger the paste-your-token box.
  TOKEN_PLACEHOLDERS = ["your_token_here", "your-token-here", "changeme"].freeze

  # GET /infra/token
  # Tells the UI whether demo/.env already carries an NGROK_AUTHTOKEN, so it
  # can show the "paste your token" box only when it is actually needed.
  def token_status
    render json: { configured: ngrok_token.present? }
  end

  # POST /infra/token
  # Writes (or replaces) NGROK_AUTHTOKEN in demo/.env. docker compose reads
  # that file on every `up`, so the next Start demo picks the token up.
  def save_token
    token = params[:token].to_s.strip
    unless token.match?(TOKEN_FORMAT)
      render json: { error: "invalid_token",
                     details: "That does not look like an ngrok authtoken. Copy it from " \
                              "https://dashboard.ngrok.com/get-started/your-authtoken." },
             status: :unprocessable_entity
      return
    end

    write_ngrok_token(token)
    render json: { configured: true }
  rescue StandardError => e
    render json: { error: "write_failed", details: e.message }, status: :internal_server_error
  end

  # POST /infra/:demo/start
  # Stops the other demos' tunnels, starts the right one. The frontend then
  # polls /infra/:demo/status until the tunnel is ready.
  def start
    if ngrok_token.blank?
      render json: { error: "missing_token",
                     details: "No usable NGROK_AUTHTOKEN found in demo/.env." },
             status: :unprocessable_entity
      return
    end

    # docker compose passes the value byte for byte, so a stray trailing space
    # or a quoted value in .env makes ngrok reject the token (ERR_NGROK_105).
    # Rewrite the line in its clean form before starting.
    normalize_env_token!

    tunnel = TUNNELS.fetch(params[:demo])
    others = ALL_SERVICES - [tunnel[:service]]

    compose("stop", *others)
    out, err, ok = compose("up", "-d", "--no-deps", tunnel[:service])
    if ok
      render json: { started: true }
    else
      render json: { error: "docker compose failed", details: err.presence || out },
             status: :internal_server_error
    end
  end

  # GET /infra/:demo/status
  # ready: true comes with "sections": one or more blocks of labelled values to
  # copy into AIsuru. A demo can expose more than one way to connect (demo2),
  # so the shape is a list rather than a single string.
  def status
    tunnel = TUNNELS.fetch(params[:demo])
    tunnels = fetch_tunnels(tunnel[:service])

    sections = tunnels.any? ? send(tunnel[:builder], tunnels) : []
    if sections.empty?
      render json: { running: false, ready: false, logs: tail_logs(tunnel[:service]) }
      return
    end

    render json: { running: true, ready: true, sections: sections }
  end

  # POST /infra/stop_all
  def stop_all
    _out, err, ok = compose("stop", *ALL_SERVICES)
    if ok
      render json: { stopped: true }
    else
      render json: { error: "docker compose failed", details: err }, status: :internal_server_error
    end
  end

  private

  # --- section builders -------------------------------------------------
  # Each returns [] when the endpoint it needs is not up yet, so the frontend
  # keeps polling.

  def mongo_sections(tunnels)
    uri = tcp_uri(tunnels)
    return [] if uri.nil?

    [{
      title: "MongoDB connection",
      rows: [
        { label: "Connection String",
          value: "mongodb://admin:adminpassword@#{uri.host}:#{uri.port}/mcp_demo?authSource=admin" },
        { label: "Database Name", value: "mcp_demo" },
      ],
    }]
  end

  def mcp_sections(tunnels)
    url = http_url(tunnels)
    return [] if url.nil?

    [{ title: "MCP server", rows: [{ label: "MCP Server URL", value: "#{url}/mcp" }] }]
  end

  # Demo 2 uses AIsuru's built-in MySQL connector, which talks raw TCP to the
  # database: what the user needs are connection parameters, not a URL.
  def mysql_sections(tunnels)
    uri = tcp_uri(tunnels)
    return [] if uri.nil?

    [{
      title: "MySQL connection",
      note: "In AIsuru add the built-in MySQL MCP server and fill in these parameters. " \
            "Leave the write switches (ALLOW_INSERT/UPDATE/DELETE/DDL_OPERATION) off " \
            "until you want the agent to modify data.",
      rows: [
        { label: "MYSQL_HOST", value: uri.host },
        { label: "MYSQL_PORT", value: uri.port.to_s },
        { label: "MYSQL_USER", value: "mcpuser" },
        { label: "MYSQL_PASS", value: "mcppassword" },
        { label: "MYSQL_DB",   value: "mcp_demo_mysql" },
      ],
    }]
  end

  def tcp_uri(tunnels)
    url = tunnels.find { |t| t["public_url"].to_s.start_with?("tcp://") }&.dig("public_url")
    url && URI.parse(url) # e.g. tcp://8.tcp.eu.ngrok.io:12345
  rescue URI::InvalidURIError
    nil
  end

  def http_url(tunnels)
    tunnels.find { |t| t["public_url"].to_s.start_with?("https://") }&.dig("public_url")
  end

  def env_path
    Rails.root.join(".env")
  end

  # Reads NGROK_AUTHTOKEN straight from demo/.env (the file docker compose
  # itself reads) rather than from ENV: the Rails process is started before the
  # user pastes the token, so its own environment would be stale.
  def ngrok_token
    return nil unless File.exist?(env_path)

    File.readlines(env_path, chomp: true).each do |line|
      next unless (m = line.match(/\A\s*NGROK_AUTHTOKEN\s*=\s*(.*)\z/))

      value = m[1].strip.delete_prefix('"').delete_suffix('"').strip
      return nil if TOKEN_PLACEHOLDERS.include?(value.downcase)
      # A malformed leftover counts as "no token": better to ask for a new one
      # than to let ngrok fail 90 seconds later.
      return nil unless value.match?(TOKEN_FORMAT)

      return value
    end
    nil
  rescue StandardError
    nil
  end

  # Rewrites the token line only if it is not already in canonical form, so
  # whitespace or quotes left by hand-editing cannot reach docker compose.
  def normalize_env_token!
    token = ngrok_token
    return if token.blank?
    return if File.exist?(env_path) &&
              File.readlines(env_path, chomp: true).include?("NGROK_AUTHTOKEN=#{token}")

    write_ngrok_token(token)
  rescue StandardError
    nil
  end

  # Replaces the NGROK_AUTHTOKEN line in place (or appends it), leaving any
  # other variable in demo/.env untouched.
  def write_ngrok_token(token)
    lines = File.exist?(env_path) ? File.readlines(env_path, chomp: true) : []
    replaced = false
    lines = lines.map do |line|
      if line.match?(/\A\s*NGROK_AUTHTOKEN\s*=/)
        replaced = true
        "NGROK_AUTHTOKEN=#{token}"
      else
        line
      end
    end
    lines << "NGROK_AUTHTOKEN=#{token}" unless replaced
    File.write(env_path, lines.join("\n") + "\n")
  end

  def compose(*args)
    out, err, exit_status = Open3.capture3("docker", "compose", *args, chdir: Rails.root.to_s)
    [out, err, exit_status.success?]
  end

  # Asks the ngrok agent (web API on port 4040, reachable by service name on
  # the compose network) which public URLs it was assigned. Returns [] while
  # the container is not up or no tunnel is established yet. An agent can hold
  # several tunnels at once (demo2), hence the array.
  def fetch_tunnels(service)
    http = Net::HTTP.new(service, 4040)
    http.open_timeout = 2
    http.read_timeout = 3
    res = http.get("/api/tunnels")
    return [] unless res.is_a?(Net::HTTPSuccess)

    JSON.parse(res.body).fetch("tunnels", [])
  rescue StandardError
    []
  end

  # Last log lines of the tunnel container: surfaces ngrok errors (bad
  # authtoken, another agent already connected...) in the UI while polling.
  def tail_logs(service)
    out, _err, ok = compose("logs", "--no-color", "--tail", "5", service)
    ok ? out : nil
  end
end
