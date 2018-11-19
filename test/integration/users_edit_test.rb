require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jurek)
  end

  test 'fails with incorrect input' do
    get edit_user_path @user
    assert_template 'users/edit'
    patch user_path, params: {user: {name: "", email: "@@@", password: "",
                                          password_confirmation: ""}}
    assert_template 'users/edit'
    assert_select "div.alert.alert-danger", /This form can't be posted due to 2 errors/
  end

  test 'is succesful with valid input' do
    get edit_user_path @user
    assert_template 'users/edit'
    patch user_path, params: {user: {name: "Kuba", email: "kuba@wp.pl", password: "",
                                          password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "Kuba"
    assert_equal @user.email, "kuba@wp.pl"


  end

end
