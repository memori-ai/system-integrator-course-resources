class Demo3Controller < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ms_callback]
  before_action :load_configuration

  DEFAULTS = {
    "ms_client_id" => "your-azure-client-id-here",
    "ms_tenant_id" => "organizations",
    "memori_id" => "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "owner_user_id" => "c3d4e5f6-a7b8-9012-cdef-123456789012",
    "tenant_id" => "www.aisuru.com",
    "engine_url" => "https://engine.memori.ai/memori/v2",
    "api_url" => "https://backend.memori.ai/api/v2",
    "base_url" => "https://www.aisuru.com",
    "trusted_app_api_key" => "your-trusted-app-api-key-here"
  }.freeze

  def index
    @current_user = User.where(id: session[:demo3_user_id]).first if session[:demo3_user_id]
  end

  def configure
    config = DemoConfig.for("demo3")
    config.merge_settings!(
      ms_client_id: params[:ms_client_id],
      ms_tenant_id: params[:ms_tenant_id],
      memori_id: params[:memori_id],
      owner_user_id: params[:owner_user_id],
      tenant_id: params[:tenant_id],
      engine_url: params[:engine_url],
      api_url: params[:api_url],
      base_url: params[:base_url],
      trusted_app_api_key: params[:trusted_app_api_key]
    )

    flash[:notice] = "Configuration saved! Now you can login with Microsoft."
    redirect_to demo3_path
  end

  # Called by frontend after Microsoft login popup succeeds
  # Receives MS user data and authenticates with AIsuru
  def ms_callback
    ms_email = params[:email]
    ms_name = params[:name]
    ms_id = params[:ms_id]

    if ms_email.blank?
      render json: { success: false, error: "Email not provided from Microsoft" }, status: :bad_request
      return
    end

    # Find or create local user
    user = User.where(email: ms_email).first
    if user.nil?
      user = User.create!(
        email: ms_email,
        name: ms_name || ms_email.split('@').first,
        password: SecureRandom.hex(16), # Random password since auth is via MS
        ms_id: ms_id
      )
      Rails.logger.info "[Demo3] Created new user: #{ms_email}"
    else
      user.update!(ms_id: ms_id) if user.ms_id.blank?
      Rails.logger.info "[Demo3] Found existing user: #{ms_email}"
    end

    # Authenticate with AIsuru using Trusted App
    if aisuru_configured?
      begin
        aisuru_result = authenticate_with_aisuru(user)
        user.update!(
          aisuru_token: aisuru_result[:token],
          aisuru_user_id: aisuru_result[:user_id]
        )
        session[:demo3_user_id] = user.id.to_s
        
        render json: { 
          success: true, 
          redirect_url: demo3_path,
          message: "Login successful! AIsuru token obtained."
        }
      rescue AisuruAuthService::AuthenticationError => e
        session[:demo3_user_id] = user.id.to_s
        render json: { 
          success: true, 
          redirect_url: demo3_path,
          warning: "Microsoft login OK, but AIsuru auth failed: #{e.message}"
        }
      end
    else
      session[:demo3_user_id] = user.id.to_s
      render json: { 
        success: true, 
        redirect_url: demo3_path,
        warning: "Microsoft login OK. Configure Trusted App to get AIsuru token."
      }
    end
  end

  def logout
    session[:demo3_user_id] = nil
    flash[:notice] = "Logged out successfully."
    redirect_to demo3_path
  end

  private

  def load_configuration
    config = DemoConfig.for("demo3")

    @ms_client_id = config.get("ms_client_id") || ENV["DEMO3_MS_CLIENT_ID"] || DEFAULTS["ms_client_id"]
    @ms_tenant_id = config.get("ms_tenant_id") || ENV["DEMO3_MS_TENANT_ID"] || DEFAULTS["ms_tenant_id"]
    @memori_id = config.get("memori_id") || ENV["DEMO3_MEMORI_ID"] || DEFAULTS["memori_id"]
    @owner_user_id = config.get("owner_user_id") || ENV["DEMO3_OWNER_USER_ID"] || DEFAULTS["owner_user_id"]
    @tenant_id = config.get("tenant_id") || ENV["DEMO3_TENANT_ID"] || DEFAULTS["tenant_id"]
    @engine_url = config.get("engine_url") || ENV["DEMO3_ENGINE_URL"] || DEFAULTS["engine_url"]
    @api_url = config.get("api_url") || ENV["DEMO3_API_URL"] || DEFAULTS["api_url"]
    @base_url = config.get("base_url") || ENV["DEMO3_BASE_URL"] || DEFAULTS["base_url"]
    @trusted_app_api_key = config.get("trusted_app_api_key") || ENV["DEMO3_TRUSTED_APP_API_KEY"] || DEFAULTS["trusted_app_api_key"]
  end

  def aisuru_configured?
    @memori_id.present? &&
    @owner_user_id.present? &&
    @trusted_app_api_key.present? &&
    @trusted_app_api_key != DEFAULTS["trusted_app_api_key"]
  end

  def ms_configured?
    @ms_client_id.present? && @ms_client_id != DEFAULTS["ms_client_id"]
  end

  def authenticate_with_aisuru(user)
    service = AisuruAuthService.new(
      api_url: @api_url,
      tenant_id: @tenant_id,
      trusted_app_api_key: @trusted_app_api_key
    )
    service.authenticate_user(user_email: user.email, user_name: user.name)
  end

  helper_method :aisuru_configured?, :ms_configured?
end

