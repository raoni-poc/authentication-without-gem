require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  attr_accessor :barer_token
  attr_accessor :user

  test "new user can sing up" do
    insert_user
    assert_response :success
  end

  test "block duplicate emails" do
    insert_user
    insert_user
    assert_response :unprocessable_entity
  end

  test "user with unconfirmed email can not login" do
    insert_user
    url = "/auth/login"
    data = { email: "raonibs89@gmail.com", password: "12345678" }.to_json
    headers = { "Content-Type" => "application/vnd.api+json" }
    post url, params: data, headers: headers
    assert_response :unauthorized
  end

  test "user can login after confirm email" do
    login_the_user
    assert_response :success
  end

  test "logged out user can not list users" do
    insert_user_and_confirm_email
    url = "/users"
    headers = { "Content-Type" => "application/vnd.api+json" }
    get url, params: nil, headers: headers
    assert_response :unauthorized
  end

  test "user can list users" do
    login_the_user
    url = "/users"
    headers = { "Content-Type" => "application/vnd.api+json", "Authorization" => "Bearer #{barer_token}" }
    get url, params: nil, headers: headers
    assert_response :success
  end

  test "user can get user by id" do
    login_the_user
    url = "/users/#{user.id}"
    headers = { "Content-Type" => "application/vnd.api+json", "Authorization" => "Bearer #{barer_token}" }
    get url, params: nil, headers: headers
    assert_response :success
  end

  private

  def insert_user
    url = "/users"
    data = { data: { type: "users", attributes: { name: "Raoni", email: "raonibs89@gmail.com", password: "12345678" } } }.to_json
    headers = { "Content-Type" => "application/vnd.api+json" }
    post url, params: data, headers: headers

    if response.status == 201
      id = JSON.parse(response.body)["data"]["id"]
      self.user = User.find(id)
    else
      self.user = User.new
    end
  end

  def insert_user_and_confirm_email
    insert_user
    self.user.confirm!
  end

  def login_the_user
    insert_user_and_confirm_email
    url = "/auth/login"
    data = { email: "raonibs89@gmail.com", password: "12345678" }.to_json
    headers = { "Content-Type" => "application/vnd.api+json" }
    post url, params: data, headers: headers
    self.barer_token = JSON.parse(response.body)["token"]
  end

end
