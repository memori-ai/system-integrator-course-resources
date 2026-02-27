# Demo 1 Controller: MongoDB via MCP Server
#
# This demo shows how an AIsuru agent can interact with a local
# MongoDB database through the MCP (Model Context Protocol) server.
# The agent reads and writes data in the mcp_demo database,
# and users can see changes live in the DB explorer panel.

class Demo1Controller < ApplicationController
  # Default values for AIsuru configuration
  DEFAULT_TENANT_ID = "www.aisuru.com".freeze
  DEFAULT_ENGINE_URL = "https://engine.memori.ai/memori/v2".freeze
  DEFAULT_API_URL = "https://backend.memori.ai/api/v2".freeze
  DEFAULT_BASE_URL = "https://www.aisuru.com".freeze

  def index
    @memori_id = params[:memori_id]
    @owner_user_id = params[:owner_user_id]
    @tenant_id = params[:tenant_id].presence || DEFAULT_TENANT_ID
    @engine_url = params[:engine_url].presence || DEFAULT_ENGINE_URL
    @api_url = params[:api_url].presence || DEFAULT_API_URL
    @base_url = params[:base_url].presence || DEFAULT_BASE_URL

    @show_agent = @memori_id.present? && @owner_user_id.present?
  end

  def configure
    redirect_to demo1_path(
      memori_id: params[:memori_id],
      owner_user_id: params[:owner_user_id],
      tenant_id: params[:tenant_id],
      engine_url: params[:engine_url],
      api_url: params[:api_url],
      base_url: params[:base_url]
    )
  end

  # AJAX endpoint: queries the mcp_demo database and returns
  # collection stats + sample documents as JSON
  def db_status
    client = Mongoid::Clients.default
    db = client.use("mcp_demo")

    collections_data = {}

    %w[products customers orders].each do |col_name|
      collection = db[col_name]
      docs = collection.find.limit(50).to_a
      collections_data[col_name] = {
        count: collection.count_documents({}),
        documents: docs.map { |d| d.transform_keys(&:to_s) }
      }
    end

    render json: {
      database: "mcp_demo",
      timestamp: Time.current.iso8601,
      collections: collections_data
    }
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
