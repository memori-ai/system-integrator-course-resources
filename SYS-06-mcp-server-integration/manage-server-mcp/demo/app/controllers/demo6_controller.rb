# Demo 6 Controller: OAuth / API connector
#
# This demo connects an AIsuru agent to an external HTTP/REST API (a fake ERP
# running in Docker) through the OAuth/API connector. The connector requests an
# OAuth2 token on its own, imports the endpoints from the OpenAPI spec and
# exposes one tool per endpoint.
#
# The live panel on the right of the page is NOT a database view: it calls the
# very same public API the agent calls, just over the compose network instead
# of the ngrok tunnel. That keeps the ERP a genuinely external service.

require "net/http"
require "uri"
require "json"

class Demo6Controller < ApplicationController
  # Default values for AIsuru configuration
  DEFAULT_TENANT_ID = "www.aisuru.com".freeze
  DEFAULT_ENGINE_URL = "https://engine.memori.ai/memori/v2".freeze
  DEFAULT_API_URL = "https://backend.memori.ai/api/v2".freeze
  DEFAULT_BASE_URL = "https://www.aisuru.com".freeze

  GESTIONALE_URL = ENV.fetch("GESTIONALE_URL", "http://gestionale:8100").freeze
  CLIENT_ID = ENV.fetch("GESTIONALE_CLIENT_ID", "aisuru-demo").freeze
  CLIENT_SECRET = ENV.fetch("GESTIONALE_CLIENT_SECRET", "demo-secret-sys06").freeze
  ADMIN_TOKEN = ENV.fetch("GESTIONALE_ADMIN_TOKEN", "sys06-demo-admin").freeze
  SCOPE = "commesse:read".freeze

  # How many rows the live panel shows. The API caps limit at 50.
  PANEL_LIMIT = 25

  def index
    # Configuration values (use params or defaults)
    @memori_id = params[:memori_id]
    @owner_user_id = params[:owner_user_id]
    @tenant_id = params[:tenant_id].presence || DEFAULT_TENANT_ID
    @engine_url = params[:engine_url].presence || DEFAULT_ENGINE_URL
    @api_url = params[:api_url].presence || DEFAULT_API_URL
    @base_url = params[:base_url].presence || DEFAULT_BASE_URL

    @show_agent = @memori_id.present? && @owner_user_id.present?

    load_dashboard if @show_agent
  end

  def configure
    # Redirect with params to show the configured agent
    redirect_to demo6_path(
      memori_id: params[:memori_id],
      owner_user_id: params[:owner_user_id],
      tenant_id: params[:tenant_id],
      engine_url: params[:engine_url],
      api_url: params[:api_url],
      base_url: params[:base_url]
    )
  end

  # AJAX endpoint: returns only the HTML of the live panel.
  def commesse
    load_dashboard
    render partial: "demo6/dashboard"
  end

  # Restores the seed data, so the demo can be run again from scratch.
  def reset
    api_post("/admin/reset", nil, admin: true)
    load_dashboard
    render partial: "demo6/dashboard"
  end

  private

  def load_dashboard
    @gestionale_offline = false
    @kpi = api_get("/kpi/riepilogo")
    page = api_get("/commesse", limit: PANEL_LIMIT)
    @commesse = page ? page["risultati"] : []
    @gestionale_offline = @kpi.nil? || page.nil?
  end

  # --- tiny OAuth2 client -----------------------------------------------
  # Same dance the connector performs: ask /token, keep the token until it is
  # about to expire, send it as a bearer header. Kept in a class variable so a
  # 5-second auto-refresh does not hammer /token.

  def access_token
    if @@token.nil? || @@token_expires_at.nil? || Time.now >= @@token_expires_at
      body = post_form("/token",
                       "grant_type" => "client_credentials",
                       "client_id" => CLIENT_ID,
                       "client_secret" => CLIENT_SECRET,
                       "scope" => SCOPE)
      return nil if body.nil?

      @@token = body["access_token"]
      # Renew a minute early, so a request never travels with a dead token.
      @@token_expires_at = Time.now + body.fetch("expires_in", 900).to_i - 60
    end
    @@token
  end

  @@token = nil
  @@token_expires_at = nil

  def http
    uri = URI.parse(GESTIONALE_URL)
    client = Net::HTTP.new(uri.host, uri.port)
    client.use_ssl = uri.scheme == "https"
    client.open_timeout = 2
    client.read_timeout = 4
    client
  end

  def post_form(path, form)
    req = Net::HTTP::Post.new(path)
    req.set_form_data(form)
    res = http.request(req)
    res.is_a?(Net::HTTPSuccess) ? JSON.parse(res.body) : nil
  rescue StandardError
    nil
  end

  # Any failure returns nil: the page must stay readable with the container
  # stopped, showing the offline notice instead of a 500.
  def api_get(path, params = {})
    token = access_token
    return nil if token.nil?

    full = params.any? ? "#{path}?#{URI.encode_www_form(params)}" : path
    req = Net::HTTP::Get.new(full)
    req["Authorization"] = "Bearer #{token}"
    res = http.request(req)
    res.is_a?(Net::HTTPSuccess) ? JSON.parse(res.body) : nil
  rescue StandardError
    nil
  end

  def api_post(path, payload, admin: false)
    req = Net::HTTP::Post.new(path)
    if admin
      req["X-Admin-Token"] = ADMIN_TOKEN
    else
      token = access_token
      return nil if token.nil?

      req["Authorization"] = "Bearer #{token}"
    end
    if payload
      req["Content-Type"] = "application/json"
      req.body = payload.to_json
    end
    res = http.request(req)
    res.is_a?(Net::HTTPSuccess) ? JSON.parse(res.body) : nil
  rescue StandardError
    nil
  end
end
