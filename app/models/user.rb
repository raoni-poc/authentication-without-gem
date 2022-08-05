class User < ApplicationRecord

  CONFIRMATION_TOKEN_EXPIRATION = 120.minutes

  before_save :downcase_email
  after_create :send_confirmation_email

  has_secure_password(:password, validations: true)

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  def confirm!
    update_columns(email_verified_at: Time.current)
  end

  def confirmed?
    email_verified_at.present?
  end

  def unconfirmed?
    !confirmed?
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :verify_email
  end

  def send_confirmation_email
    #UserMailer.confirmation(self).deliver_later
    file = File.open("public/confirmation_tokens/#{self.email}.txt", "w")
    file.write(generate_confirmation_token)
    file.close
    puts 'THIS IS TOKEN: '+generate_confirmation_token
  end

  private

  def downcase_email
    self.email = email.downcase
  end

end
