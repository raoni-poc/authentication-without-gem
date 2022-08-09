class ConfirmationsController < ApplicationController
  def email
    token = params[:confirmation_token]
    user = User.find_signed(token, purpose: :verify_email)

    if user.nil?
      return render :json => "Invalid token"
    end

    if user.present? and user.unconfirmed?
      user.confirm!
      return render :json => "Your email has been confirmed."
    end

    if user.confirmed?
      return render :json => "Your email has already been confirmed."
    end
  end
end
