class Demo3Controller < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ms_callback]
  before_action :load_configuration

  # Default Microsoft configuration
  DEFAULT_MS_CLIENT_ID = "your-azure-client-id-here"
  DEFAULT_MS_TENANT_ID = "organizations" # or "common" or specific tenant ID
  
  # Default AIsuru configuration (same as Demo 2)
  DEFAULT_MEMORI_ID = "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
  DEFAULT_OWNER_USER_ID = "c3d4e5f6-a7b8-9012-cdef-123456789012"
  DEFAULT_TENANT_ID = "www.aisuru.com"
  DEFAULT_ENGINE_URL = "https://engine.memori.ai/memori/v2"
  DEFAULT_API_URL = "https://backend.memori.ai/api/v2"
  DEFAULT_BASE_URL = "https://www.aisuru.com"
  DEFAULT_TRUSTED_APP_API_KEY = "your-trusted-app-api-key-here"

  def index
    @current_user = User.where(id: session[:demo3_user_id]).first if session[:demo3_user_id]
  end

  def configure
    # Microsoft settings
    session[:demo3_ms_client_id] = params[:ms_client_id]
    session[:demo3_ms_tenant_id] = params[:ms_tenant_id]
    
    # AIsuru settings
    session[:demo3_memori_id] = params[:memori_id]
    session[:demo3_owner_user_id] = params[:owner_user_id]
    session[:demo3_tenant_id] = params[:tenant_id]
    session[:demo3_engine_url] = params[:engine_url]
    session[:demo3_api_url] = params[:api_url]
    session[:demo3_base_url] = params[:base_url]
    session[:demo3_trusted_app_api_key] = params[:trusted_app_api_key]
    
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
    # Microsoft settings
    @ms_client_id = session[:demo3_ms_client_id] || DEFAULT_MS_CLIENT_ID
    @ms_tenant_id = session[:demo3_ms_tenant_id] || DEFAULT_MS_TENANT_ID
    
    # AIsuru settings
    @memori_id = session[:demo3_memori_id] || DEFAULT_MEMORI_ID
    @owner_user_id = session[:demo3_owner_user_id] || DEFAULT_OWNER_USER_ID
    @tenant_id = session[:demo3_tenant_id] || DEFAULT_TENANT_ID
    @engine_url = session[:demo3_engine_url] || DEFAULT_ENGINE_URL
    @api_url = session[:demo3_api_url] || DEFAULT_API_URL
    @base_url = session[:demo3_base_url] || DEFAULT_BASE_URL
    @trusted_app_api_key = session[:demo3_trusted_app_api_key] || DEFAULT_TRUSTED_APP_API_KEY
  end

  def aisuru_configured?
    @memori_id.present? && 
    @owner_user_id.present? && 
    @trusted_app_api_key.present? && 
    @trusted_app_api_key != DEFAULT_TRUSTED_APP_API_KEY
  end

  def ms_configured?
    @ms_client_id.present? && @ms_client_id != DEFAULT_MS_CLIENT_ID
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

