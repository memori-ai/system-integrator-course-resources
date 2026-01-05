# Demo 2 Controller: Programmatic Authentication with Trusted App
# 
# This demo shows how to:
# 1. Create a simple internal user authentication system
# 2. Use AIsuru Trusted App API to authenticate users programmatically
# 3. Pass the authentication token to the web component
#
# Documentation: https://docs.aisuru.com/api/backend/pwluser

class Demo2Controller < ApplicationController
  # Default values for AIsuru configuration
  DEFAULT_TENANT_ID = "www.aisuru.com".freeze
  DEFAULT_ENGINE_URL = "https://engine.memori.ai/memori/v2".freeze
  DEFAULT_API_URL = "https://backend.memori.ai/api/v2".freeze
  DEFAULT_BASE_URL = "https://www.aisuru.com".freeze

  # Demo user credentials
  DEMO_USER_EMAIL = "demo@demo.com".freeze
  DEMO_USER_PASSWORD = "demodemo".freeze
  DEMO_USER_NAME = "Demo User".freeze

  before_action :load_configuration
  before_action :ensure_demo_user_exists, only: [:index, :login]

  def index
    @current_user = find_current_user
    @aisuru_configured = aisuru_configured?
  end

  def login
    @current_user = find_current_user
  end

  def authenticate
    email = params[:email]
    password = params[:password]

    user = User.find_by(email: email)

    if user&.authenticate(password)
      # Store user in session
      session[:user_id] = user.id.to_s

      # If AIsuru is configured, authenticate with AIsuru
      if aisuru_configured?
        begin
          aisuru_result = authenticate_with_aisuru(user)
          user.update(
            aisuru_token: aisuru_result[:token],
            aisuru_user_id: aisuru_result[:user_id]
          )
          flash[:notice] = "✅ Logged in successfully! AIsuru authentication completed."
        rescue AisuruAuthService::AuthenticationError => e
          flash[:alert] = "⚠️ Logged in locally, but AIsuru authentication failed: #{e.message}"
        end
      else
        flash[:notice] = "✅ Logged in successfully! Configure Trusted App to enable AIsuru authentication."
      end

      redirect_to demo2_path
    else
      flash[:alert] = "❌ Invalid email or password. Try demo@demo.com / demodemo"
      redirect_to demo2_login_path
    end
  end

  def configure
    # Save AIsuru configuration in session
    session[:demo2_config] = {
      memori_id: params[:memori_id],
      owner_user_id: params[:owner_user_id],
      tenant_id: params[:tenant_id].presence || DEFAULT_TENANT_ID,
      engine_url: params[:engine_url].presence || DEFAULT_ENGINE_URL,
      api_url: params[:api_url].presence || DEFAULT_API_URL,
      base_url: params[:base_url].presence || DEFAULT_BASE_URL,
      trusted_app_api_key: params[:trusted_app_api_key]
    }

    flash[:notice] = "✅ Configuration saved! Now login to see the authenticated web component."
    redirect_to demo2_path
  end

  def logout
    # Clear user session
    user = find_current_user
    user&.clear_aisuru_token!
    
    session.delete(:user_id)
    flash[:notice] = "👋 Logged out successfully!"
    redirect_to demo2_path
  end

  private

  def load_configuration
    config = session[:demo2_config] || {}
    
    @memori_id = config[:memori_id]
    @owner_user_id = config[:owner_user_id]
    @tenant_id = config[:tenant_id] || DEFAULT_TENANT_ID
    @engine_url = config[:engine_url] || DEFAULT_ENGINE_URL
    @api_url = config[:api_url] || DEFAULT_API_URL
    @base_url = config[:base_url] || DEFAULT_BASE_URL
    @trusted_app_api_key = config[:trusted_app_api_key]
  end

  def find_current_user
    return nil unless session[:user_id]
    User.find(session[:user_id]) rescue nil
  end

  def ensure_demo_user_exists
    # Create demo user if it doesn't exist
    unless User.find_by(email: DEMO_USER_EMAIL)
      User.create!(
        email: DEMO_USER_EMAIL,
        password: DEMO_USER_PASSWORD,
        name: DEMO_USER_NAME
      )
      Rails.logger.info "Created demo user: #{DEMO_USER_EMAIL}"
    end
  end

  def aisuru_configured?
    @memori_id.present? && 
    @owner_user_id.present? && 
    @trusted_app_api_key.present?
  end

  def authenticate_with_aisuru(user)
    service = AisuruAuthService.new(
      api_url: @api_url,
      tenant_id: @tenant_id,
      trusted_app_api_key: @trusted_app_api_key
    )

    service.authenticate_user(
      user_email: user.email,
      user_name: user.name
    )
  end
end

