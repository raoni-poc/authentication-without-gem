class AuthenticationController < ApplicationController
  include JwtHelper

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
    user = User.find_by_email(params[:email])
    user.send_recover_password
    render json: { msg: 'check link in your email' }, status: :ok
  end

  def recover_password
    token = params[:recover_token]
    user = User.find_signed(token, purpose: :recover_token)

    if user.nil? || user.unconfirmed? || user.email != params[:email]
      return render :json => "Unauthorized", status: :unauthorized
    end

    begin
      user.password = params[:password]
      user.save
    rescue ActiveRecord::RecordInvalid => e
      return render json: { errors: e.message }, status: :bad_request
    end

    return render json: { msg: 'password altered' }, status: :ok

  end
end
