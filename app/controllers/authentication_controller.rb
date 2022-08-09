class AuthenticationController < ApplicationController
  include JwtHelper
  before_action :authorize_request, only: [:request_password_change]

  def login
    user = User.find_by_email(params[:email])

    if authenticate(user, params[:password])
      token = encoder(user_id: user.id)
      time = Time.now + 4.hours.to_i
      render json: { token: token,
                     exp: time.strftime("%m-%d-%Y %H:%M"),
                     email: user.email }, status: :ok
    else
      render json: {
        error: 'unauthorized',
      }, status: :unauthorized
    end
  end

  def request_password_change
    self.user.send_recover_password
    render json: { msg: 'check link in your email'}, status: :ok
  end

  def recover_password
    token = params[:recover_password]
    user = User.find_signed(token, purpose: :recover_password)

    if user.nil? || user.unconfirmed? || user.email != params[:email]
      return render :json => "Unauthorized", status: :unauthorized
    end

    begin
      user.password = params[:password]
      user.save
    rescue ActiveRecord::RecordInvalid => e
      return render json: { errors: e.message }, status: :bad_request
    end

    private

    def login_params
      params.permit(:email, :password)
    end

    def change_password_params
      params.permit(:email, :recover_password)
    end
  end
end
