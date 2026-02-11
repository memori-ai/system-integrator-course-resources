# Demo 2 Controller: MySQL via MCP Server
#
# This demo shows how an AIsuru agent can interact with a local
# MySQL database through a self-hosted MCP server (from npm package).
# The agent reads and writes data in the mcp_demo_mysql database,
# and users can see changes live in the DB explorer panel.

class Demo2Controller < ApplicationController
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
    redirect_to demo2_path(
      memori_id: params[:memori_id],
      owner_user_id: params[:owner_user_id],
      tenant_id: params[:tenant_id],
      engine_url: params[:engine_url],
      api_url: params[:api_url],
      base_url: params[:base_url]
    )
  end

  # AJAX endpoint: queries the mcp_demo_mysql database and returns
  # table stats + sample records as JSON
  def db_status
    require 'mysql2'

    client = Mysql2::Client.new(
      host: ENV['MYSQL_HOST'] || 'localhost',
      port: ENV['MYSQL_PORT']&.to_i || 3306,
      database: 'mcp_demo_mysql',
      username: ENV['MYSQL_USER'] || 'mcpuser',
      password: ENV['MYSQL_PASSWORD'] || 'mcppassword'
    )

    tables_data = {}

    %w[users products orders].each do |table_name|
      # Get table row count
      count_result = client.query("SELECT COUNT(*) as count FROM #{table_name}")
      count = count_result.first['count']

      # Get sample records (limit 50)
      records = client.query("SELECT * FROM #{table_name} LIMIT 50", as: :hash).to_a

      tables_data[table_name] = {
        count: count,
        records: records
      }
    end

    client.close

    render json: {
      database: "mcp_demo_mysql",
      timestamp: Time.current.iso8601,
      tables: tables_data
    }
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
