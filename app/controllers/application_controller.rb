class ApplicationController < ActionController::Base
  include JSONAPI::ActsAsResourceController
  include JwtHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  attr_accessor :current_user

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = decoder(token)
      self.current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: {
        errors: e.message
      }, status: :unauthorized
    end
  end

  def is_owner
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = decoder(token)
      user = User.find(decoded[:user_id])
      if user.id != params[:id].to_i
        render json: {
          errors: '404 not found'
        }, status: :not_found
      end
    end
  end

end
