require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jurek)
    @user2 = users(:agatka)
  end

  test 'fails with incorrect input' do
    log_in_as @user
    get edit_user_path @user
    assert_template 'users/edit'
    patch user_path, params: {user: {name: "", email: "@@@", password: "",
                                          password_confirmation: ""}}
    assert_template 'users/edit'
    assert_select "div.alert.alert-danger", /This form can't be posted due to 2 errors/
  end

  test 'is succesful with valid input and friendly redirect' do
    get edit_user_path @user
    assert_template 'sessions/new'
    log_in_as @user
    assert_template 'users/edit'
    patch user_path, params: {user: {name: "Kuba", email: "kuba@wp.pl", password: "",
                                          password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "Kuba"
    assert_equal @user.email, "kuba@wp.pl"
  end

  test 'sends not logged user to the login page' do
    get edit_user_path @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: {name: "new_name",
                                            email: "new_email"}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'redirects to home page user who tries to edit other users' do
    log_in_as @user
    get edit_user_path @user2
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test 'redirects to home page user who tries to update uther users' do
    log_in_as @user
    patch user_path(@user2), params: {user: {name: "new_name",
                                            email: "new_email"}}
    assert_not flash.empty?
    assert_redirected_to root_path
  end


end
