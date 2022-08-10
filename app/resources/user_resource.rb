class UserResource < JSONAPI::Resource
  attributes :name, :email, :password

  def fetchable_fields
      super - [:password]
  end
end