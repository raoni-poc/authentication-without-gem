class UserResource < JSONAPI::Resource
  attributes :name, :email, :password_digest
end