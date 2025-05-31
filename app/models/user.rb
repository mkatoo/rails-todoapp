class User < ApplicationRecord
  has_secure_password

  validates :name, length: { in: 3..10 }
  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    presence: true,
    uniqueness: { case_sensitive: false }
end
