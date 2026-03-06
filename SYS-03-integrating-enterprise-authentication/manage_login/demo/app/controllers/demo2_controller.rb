# Demo 2 Controller: Programmatic Authentication with Trusted App
# 
# This demo shows how to:
# 1. Create a simple internal user authentication system
# 2. Use AIsuru Trusted App API to authenticate users programmatically
# 3. Pass the authentication token to the web component
#
# Documentation: https://docs.aisuru.com/api/backend/pwluser

class Demo2Controller < ApplicationController
  DEFAULTS = {
    "tenant_id" => "www.aisuru.com",
    "engine_url" => "https://engine.memori.ai/memori/v2",
    "api_url" => "https://backend.memori.ai/api/v2",
    "base_url" => "https://www.aisuru.com"
  }.freeze

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

    user = User.where(email: email).first

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
    config = DemoConfig.for("demo2")
    config.merge_settings!(
      memori_id: params[:memori_id],
      owner_user_id: params[:owner_user_id],
      tenant_id: params[:tenant_id].presence || DEFAULTS["tenant_id"],
      engine_url: params[:engine_url].presence || DEFAULTS["engine_url"],
      api_url: params[:api_url].presence || DEFAULTS["api_url"],
      base_url: params[:base_url].presence || DEFAULTS["base_url"],
      trusted_app_api_key: params[:trusted_app_api_key]
    )

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
    config = DemoConfig.for("demo2")

    @memori_id = config.get("memori_id") || ENV["DEMO2_MEMORI_ID"]
    @owner_user_id = config.get("owner_user_id") || ENV["DEMO2_OWNER_USER_ID"]
    @tenant_id = config.get("tenant_id") || ENV["DEMO2_TENANT_ID"] || DEFAULTS["tenant_id"]
    @engine_url = config.get("engine_url") || ENV["DEMO2_ENGINE_URL"] || DEFAULTS["engine_url"]
    @api_url = config.get("api_url") || ENV["DEMO2_API_URL"] || DEFAULTS["api_url"]
    @base_url = config.get("base_url") || ENV["DEMO2_BASE_URL"] || DEFAULTS["base_url"]
    @trusted_app_api_key = config.get("trusted_app_api_key") || ENV["DEMO2_TRUSTED_APP_API_KEY"]
  end

  def find_current_user
    return nil unless session[:user_id]
    User.find(session[:user_id]) rescue nil
  end

  def ensure_demo_user_exists
    # Create demo user if it doesn't exist
    # Use where().first to avoid Mongoid raising exception
    unless User.where(email: DEMO_USER_EMAIL).first
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

