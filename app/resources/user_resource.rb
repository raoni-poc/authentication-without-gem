class UserResource < JSONAPI::Resource
  attributes :name, :email, :password
end