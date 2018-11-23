require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'not creating invalid user' do
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                        email: "invalid",
                                        password: "",
                                        password_confirmation: "tarara"}}
    end
    assert_template 'users/new'
    assert_select 'div.alert.alert-danger'
    assert_select 'div#error_explanation'
    assert_select 'form[action="/users"]'
  end

  test 'create valid user' do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "validname",
                                        email: 'email@valid.com',
                                        password: "haslo1",
                                        password_confirmation: "haslo1"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    #Try to login before activation
    log_in_as(user)
    assert_not is_logged_in?

    # Invalid activation_token
    get edit_account_activation_url("invalid_token", email: user.email)
    assert_not is_logged_in?

    # Valid activation token, incorrect email
    get edit_account_activation_url(user.activation_token, email: "invalid_token")
    assert_not is_logged_in?

    #Activate user with correct credentials
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
