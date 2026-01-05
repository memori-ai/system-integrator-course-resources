class Demo4Controller < ApplicationController
  before_action :ensure_demo_user_exists, only: [:index, :login]
  before_action :load_configuration

  DEMO_USER_EMAIL = "demo@demo.com"
  DEMO_USER_PASSWORD = "demodemo"

  # Default AIsuru configuration
  DEFAULT_MEMORI_ID = "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
  DEFAULT_OWNER_USER_ID = "c3d4e5f6-a7b8-9012-cdef-123456789012"
  DEFAULT_TENANT_ID = "www.aisuru.com"
  DEFAULT_API_URL = "https://backend.memori.ai/api/v2"
  DEFAULT_BASE_URL = "https://www.aisuru.com"
  DEFAULT_TRUSTED_APP_API_KEY = "your-trusted-app-api-key-here"
  DEFAULT_UI_LANG = "en"

  def index
    @current_user = User.where(id: session[:demo4_user_id]).first if session[:demo4_user_id]
  end

  def login
    @current_user = User.where(id: session[:demo4_user_id]).first if session[:demo4_user_id]
  end

  def authenticate
    user = User.where(email: params[:email]).first

    if user && user.authenticate(params[:password])
      session[:demo4_user_id] = user.id.to_s

      if aisuru_configured?
        begin
          aisuru_result = authenticate_with_aisuru(user)
          user.update!(aisuru_token: aisuru_result[:token], aisuru_user_id: aisuru_result[:user_id])
          flash[:notice] = "Login successful! AIsuru token obtained. You can now redirect to AIsuru."
        rescue AisuruAuthService::AuthenticationError => e
          flash[:alert] = "Login OK, but AIsuru authentication failed: #{e.message}"
        end
      else
        flash[:alert] = "Login OK. Configure Trusted App to enable AIsuru redirect."
      end
      redirect_to demo4_path
    else
      flash[:alert] = "Invalid email or password."
      redirect_to demo4_login_path
    end
  end

  def logout
    session[:demo4_user_id] = nil
    flash[:notice] = "Logged out successfully."
    redirect_to demo4_path
  end

  def configure
    session[:demo4_tenant_id] = params[:tenant_id]
    session[:demo4_api_url] = params[:api_url]
    session[:demo4_base_url] = params[:base_url]
    session[:demo4_trusted_app_api_key] = params[:trusted_app_api_key]
    session[:demo4_ui_lang] = params[:ui_lang]
    flash[:notice] = "Configuration saved!"
    redirect_to demo4_path
  end

  # Redirect to AIsuru tenant with magic link
  def redirect_to_aisuru
    @current_user = User.where(id: session[:demo4_user_id]).first

    if @current_user.nil?
      flash[:alert] = "Please login first."
      redirect_to demo4_login_path
      return
    end

    unless @current_user.aisuru_authenticated?
      flash[:alert] = "No AIsuru token. Configure Trusted App and re-login."
      redirect_to demo4_path
      return
    end

    # Build the magic link URL
    # Format: https://{tenant}/{lang}/magiclink/{token}
    magic_link_url = build_magic_link_url(@current_user.aisuru_token)
    
    redirect_to magic_link_url, allow_other_host: true
  end

  private

  def ensure_demo_user_exists
    unless User.where(email: DEMO_USER_EMAIL).first
      User.create!(
        email: DEMO_USER_EMAIL,
        password: DEMO_USER_PASSWORD,
        name: "Demo User"
      )
      Rails.logger.info "[Demo4] Created demo user: #{DEMO_USER_EMAIL}"
    end
  end

  def load_configuration
    @tenant_id = session[:demo4_tenant_id] || DEFAULT_TENANT_ID
    @api_url = session[:demo4_api_url] || DEFAULT_API_URL
    @base_url = session[:demo4_base_url] || DEFAULT_BASE_URL
    @trusted_app_api_key = session[:demo4_trusted_app_api_key] || DEFAULT_TRUSTED_APP_API_KEY
    @ui_lang = session[:demo4_ui_lang] || DEFAULT_UI_LANG
  end

  def aisuru_configured?
    @trusted_app_api_key.present? && @trusted_app_api_key != DEFAULT_TRUSTED_APP_API_KEY
  end

  def authenticate_with_aisuru(user)
    service = AisuruAuthService.new(
      api_url: @api_url,
      tenant_id: @tenant_id,
      trusted_app_api_key: @trusted_app_api_key
    )
    service.authenticate_user(user_email: user.email, user_name: user.name)
  end

  def build_magic_link_url(token)
    # URL format: https://www.aisuru.com/it/magiclink/{token}
    # or for custom tenants: https://{tenant}/{lang}/magiclink/{token}
    lang = @ui_lang.downcase
    "#{@base_url}/#{lang}/magiclink/#{token}"
  end

  helper_method :aisuru_configured?
end

