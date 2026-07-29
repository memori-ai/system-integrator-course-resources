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
  TUNNELS = {
    "demo1" => { service: "ngrok-mongo",     kind: :tcp  },
    "demo2" => { service: "ngrok-mcp-mysql", kind: :http },
    "demo3" => { service: "ngrok-mcp",       kind: :http },
  }.freeze
  ALL_SERVICES = TUNNELS.values.map { |t| t[:service] }.freeze

  # POST /infra/:demo/start
  # Stops the other demos' tunnels, starts the right one. The frontend then
  # polls /infra/:demo/status until the tunnel is ready.
  def start
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
  # ready: true comes with the value to paste into AIsuru (connection string
  # for the MongoDB TCP tunnel, https URL + /mcp for the HTTP tunnels).
  def status
    tunnel = TUNNELS.fetch(params[:demo])
    public_url = fetch_tunnel_url(tunnel[:service])

    if public_url.nil?
      render json: { running: false, ready: false, logs: tail_logs(tunnel[:service]) }
      return
    end

    payload = { running: true, ready: true, public_url: public_url }
    if tunnel[:kind] == :tcp
      uri = URI.parse(public_url) # e.g. tcp://8.tcp.eu.ngrok.io:12345
      payload[:connection_string] =
        "mongodb://admin:adminpassword@#{uri.host}:#{uri.port}/mcp_demo?authSource=admin"
      payload[:database] = "mcp_demo"
    else
      payload[:mcp_url] = "#{public_url}/mcp"
    end
    render json: payload
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

  def compose(*args)
    out, err, exit_status = Open3.capture3("docker", "compose", *args, chdir: Rails.root.to_s)
    [out, err, exit_status.success?]
  end

  # Asks the ngrok agent (web API on port 4040, reachable by service name on
  # the compose network) which public URL it was assigned. Returns nil while
  # the container is not up or the tunnel is not established yet.
  def fetch_tunnel_url(service)
    http = Net::HTTP.new(service, 4040)
    http.open_timeout = 2
    http.read_timeout = 3
    res = http.get("/api/tunnels")
    return nil unless res.is_a?(Net::HTTPSuccess)

    JSON.parse(res.body).fetch("tunnels", []).dig(0, "public_url")
  rescue StandardError
    nil
  end

  # Last log lines of the tunnel container: surfaces ngrok errors (bad
  # authtoken, another agent already connected...) in the UI while polling.
  def tail_logs(service)
    out, _err, ok = compose("logs", "--no-color", "--tail", "5", service)
    ok ? out : nil
  end
end
