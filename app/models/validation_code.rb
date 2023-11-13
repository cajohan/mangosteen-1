class ValidationCode < ApplicationRecord
  # has_secure_token :code, length: 24
  # email必填
  validates :email, presence: true
end
