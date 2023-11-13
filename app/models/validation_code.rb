class ValidationCode < ApplicationRecord
  # has_secure_token :code, length: 24
  # email必填
  validates :email, presence: true

  before_create :generate_code
  after_create :send_email

  def generate_code
    self.code = SecureRandom.random_number.to_s[2..7]
  end
  def send_email
    UserMailer.welcome_email(self.email)
  end
end
