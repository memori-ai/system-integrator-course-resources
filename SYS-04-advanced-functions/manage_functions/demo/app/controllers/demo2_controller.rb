# Demo 2 Controller: Using Swagger Files
#
# This demo shows how to use OpenAPI/Swagger files to automatically
# generate multiple advanced functions and integrate them into an AIsuru agent.

class Demo2Controller < ApplicationController
  # Default values for AIsuru configuration
  DEFAULT_TENANT_ID = "www.aisuru.com".freeze
  DEFAULT_ENGINE_URL = "https://engine.memori.ai/memori/v2".freeze
  DEFAULT_API_URL = "https://backend.memori.ai/api/v2".freeze
  DEFAULT_BASE_URL = "https://www.aisuru.com".freeze

  def index
    # Configuration values (use params or defaults)
    @memori_id = params[:memori_id]
    @owner_user_id = params[:owner_user_id]
    @tenant_id = params[:tenant_id].presence || DEFAULT_TENANT_ID
    @engine_url = params[:engine_url].presence || DEFAULT_ENGINE_URL
    @api_url = params[:api_url].presence || DEFAULT_API_URL
    @base_url = params[:base_url].presence || DEFAULT_BASE_URL

    @show_agent = @memori_id.present? && @owner_user_id.present?
  end

  def configure
    # Redirect with params to show the configured agent
    redirect_to demo2_path(
      memori_id: params[:memori_id],
      owner_user_id: params[:owner_user_id],
      tenant_id: params[:tenant_id],
      engine_url: params[:engine_url],
      api_url: params[:api_url],
      base_url: params[:base_url]
    )
  end

  def download_swagger
    # Send the swagger file for download
    swagger_file_path = Rails.root.join("swaggerfile_aisuru.json")

    if File.exist?(swagger_file_path)
      send_file swagger_file_path,
                filename: "swaggerfile_aisuru.json",
                type: "application/json",
                disposition: "attachment"
    else
      redirect_to demo2_path, alert: "Swagger file not found."
    end
  end
end
