class User < ApplicationRecord

  TOKEN_EXPIRATION = 120.minutes

  before_save :downcase_email
  after_create :send_confirmation_email

  has_secure_password(:password, validations: true)

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, presence: true, length: {minimum: 8}

  def confirm!
    update_columns(email_verified_at: Time.current)
  end

  def confirmed?
    email_verified_at.present?
  end

  def unconfirmed?
    !confirmed?
  end

  def send_confirmation_email
    confirmation_token = signed_id expires_in: TOKEN_EXPIRATION, purpose: :verify_email
    #UserMailer.confirmation(self).deliver_later
    file = File.open("public/confirmation_tokens/#{self.email}.txt", "w")
    file.write(confirmation_token)
    file.close
    puts 'CONFIRMATION TOKEN: '+ confirmation_token
  end

  def send_recover_password
    recover_token = signed_id expires_in: TOKEN_EXPIRATION, purpose: :recover_password
    #UserMailer.confirmation(self).deliver_later
    file = File.open("public/confirmation_tokens/#{self.email}.txt", "w")
    file.write(recover_token)
    file.close
    puts 'CHANGE PASSWORD TOKEN: '+recover_token
  end


  private

  def downcase_email
    self.email = email.downcase
  end

end
