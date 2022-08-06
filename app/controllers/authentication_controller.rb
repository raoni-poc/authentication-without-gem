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

  private

  def login_params
    params.permit(:email, :password)
  end

end
