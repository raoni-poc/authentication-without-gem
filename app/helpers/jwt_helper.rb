module JwtHelper
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

    def encoder(payload, exp = 4.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def decoder(token)
      decoded = JWT.decode(token, SECRET_KEY, true)[0]
      return HashWithIndifferentAccess.new decoded
    end

    def authenticate(user, password)
      (!user.nil? and BCrypt::Password.new(user.password_digest) == password and user.confirmed?) or false
    end
end