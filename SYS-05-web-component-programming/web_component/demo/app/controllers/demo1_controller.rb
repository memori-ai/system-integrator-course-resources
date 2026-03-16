# Demo 1 Controller: Agent to Control Page Content
#
# This demo shows how to make an AIsuru agent aware of the web page it is
# embedded in and how to trigger DOM actions from agent responses.

class Demo1Controller < ApplicationController
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

  def download_prompt
    prompt_file_path = Rails.root.join("agent_prompt.txt")

    if File.exist?(prompt_file_path)
      send_file prompt_file_path,
                filename: "agent_prompt.txt",
                type: "text/plain",
                disposition: "attachment"
    else
      redirect_to demo1_path, alert: "Prompt file not found."
    end
  end
end
