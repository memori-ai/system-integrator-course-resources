# User model for Demo 2 & 3 - Programmatic Authentication
# This is a simple user model to demonstrate how to integrate
# AIsuru authentication with your own user system.

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Basic authentication fields
  field :email, type: String
  field :password_digest, type: String
  field :name, type: String

  # Microsoft authentication (Demo 3)
  field :ms_id, type: String

  # AIsuru integration fields
  field :aisuru_token, type: String
  field :aisuru_user_id, type: String

  # Indexes
  index({ email: 1 }, { unique: true })
  index({ ms_id: 1 }, { sparse: true })

  # Validations
  validates :email, presence: true, uniqueness: true
  # password_digest is optional for MS-authenticated users

  # Simple password handling (for demo purposes)
  # In production, use bcrypt or devise
  def password=(plain_password)
    self.password_digest = Digest::SHA256.hexdigest(plain_password)
  end

  def authenticate(plain_password)
    password_digest == Digest::SHA256.hexdigest(plain_password)
  end

  # Check if user has a valid AIsuru token
  def aisuru_authenticated?
    aisuru_token.present?
  end

  # Clear AIsuru session
  def clear_aisuru_token!
    update(aisuru_token: nil, aisuru_user_id: nil)
  end
end

