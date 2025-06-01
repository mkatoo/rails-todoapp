class User < ApplicationRecord
  has_secure_password

  validates :name, length: { in: 3..10 }
  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    presence: true,
    uniqueness: { case_sensitive: false }

  after_initialize :set_token, if: :new_record?

  private

  def set_token
    self.token = SecureRandom.uuid
  end
end
