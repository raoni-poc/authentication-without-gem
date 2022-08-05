class User < ApplicationRecord
  before_save :downcase_email

  has_secure_password(:password, validations: true)

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  def downcase_email
    self.email = email.downcase
  end

end
