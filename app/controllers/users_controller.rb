class UsersController < ApplicationController
    include JSONAPI::ActsAsResourceController
    before_action :authorize_request, except: :create
    before_action :is_owner, except: [:index, :create]
end