class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 3, allow_nil: true }

  after_initialize :ensure_session_token
  attr_reader :password

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def self.find_by_credentials(params)
    user = User.find_by_username(params[:username])
    return nil if user.nil?
    user.is_password?(params[:password]) ? user : nil
  end
  
  def reset_session_token!
    self.session_token = self.class.generate_session_token
    save!
    session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
