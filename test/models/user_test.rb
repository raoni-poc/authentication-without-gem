require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "should save a valid user" do
    user = User.new
    user.name = Faker::Name.first_name
    user.email = Faker::Internet.email
    user.password = Faker::Internet.password
    assert user.save
  end

  test "should not save user without name" do
    user = User.new
    user.email = Faker::Internet.email
    user.password = Faker::Internet.password
    assert_not user.save
  end

  test "should not save user without email" do
    user = User.new
    user.name = Faker::Name.first_name
    user.password = Faker::Internet.password
    assert_not user.save
  end

  test "should not save user without password" do
    user = User.new
    user.name = Faker::Name.first_name
    user.email = Faker::Internet.email
    assert_not user.save
  end

end
