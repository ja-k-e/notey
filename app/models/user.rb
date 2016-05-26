class User < ActiveRecord::Base
  has_secure_password
  has_many :notes, inverse_of: :user, dependent: :destroy

  validates :username, presence: true, uniqueness: true, length: { in: 3..20 }
  validates :password, length: { in: 6..20 }, on: :create

  before_save :set_api_key
  before_save :encrypt_password
  after_save :clear_password

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end

  def set_api_key
    self.api_key = SecureRandom.hex(24)
  end
end
