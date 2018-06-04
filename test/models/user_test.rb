require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@gmail.com",
      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a"*1000
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a"*1000+"@gmail.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@gmail.com user@example.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMple.cOM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  test "password should have a minium length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  test "authenticated? ret false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end
