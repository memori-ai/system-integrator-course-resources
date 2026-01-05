# AIsuru Authentication Service
# Handles authentication with AIsuru Backend API using Trusted App credentials
#
# Documentation: https://docs.aisuru.com/api/backend/pwluser

require "net/http"
require "json"
require "jwt"

class AisuruAuthService
  class AuthenticationError < StandardError; end

  def initialize(api_url:, tenant_id:, trusted_app_api_key:)
    @api_url = api_url
    @tenant_id = tenant_id
    @trusted_app_api_key = trusted_app_api_key
  end

  # Authenticate user via LoginWithJWT
  # This creates or finds the user in AIsuru and returns an auth token
  #
  # @param user_email [String] User's email address
  # @param user_name [String] User's display name
  # @return [Hash] { token: String, user_id: String }
  def authenticate_user(user_email:, user_name:)
    # Create JWT payload for the user
    jwt_payload = create_jwt_payload(user_email, user_name)
    
    # Sign JWT with the Trusted App API key
    jwt_token = JWT.encode(jwt_payload, @trusted_app_api_key, "HS256")
    
    # Call AIsuru LoginWithJWT endpoint
    response = call_login_with_jwt(jwt_token)
    
    parse_auth_response(response)
  end

  private

  def create_jwt_payload(email, name)
    {
      sub: email,           # Subject (user identifier)
      email: email,
      name: name,
      tenant: @tenant_id,
      iat: Time.now.to_i,   # Issued at
      exp: Time.now.to_i + 300  # Expires in 5 minutes
    }
  end

  def call_login_with_jwt(jwt_token)
    uri = URI("#{@api_url}/LoginWithJWT")
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    http.read_timeout = 30
    
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Accept"] = "application/json"
    # Trusted App API key goes in X-Memori-Trusted-App header
    request["X-Memori-Trusted-App"] = @trusted_app_api_key
    
    # Body uses jwtToken (not jwt)
    body = {
      tenant: @tenant_id,
      jwtToken: jwt_token
    }
    request.body = body.to_json
    
    Rails.logger.info "[AIsuru] Calling LoginWithJWT for tenant: #{@tenant_id}"
    
    response = http.request(request)
    
    Rails.logger.info "[AIsuru] Response status: #{response.code}"
    
    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error "[AIsuru] API call failed: #{e.message}"
    raise AuthenticationError, "Failed to connect to AIsuru API: #{e.message}"
  end

  def parse_auth_response(response)
    if response["resultCode"] == 0
      {
        token: response["token"],
        user_id: response.dig("user", "userID"),
        user_name: response.dig("user", "userName"),
        email: response.dig("user", "eMail")
      }
    else
      error_message = response["resultMessage"] || "Unknown error"
      Rails.logger.error "[AIsuru] Authentication failed: #{error_message}"
      raise AuthenticationError, "AIsuru authentication failed: #{error_message}"
    end
  end
end

