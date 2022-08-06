class UsersController < ApplicationController
    before_action :authorize_request, except: :create
end
