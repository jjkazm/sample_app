require 'test_helper'

class PasswordsResetTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:jurek)
  end

  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, params: {password_reset: {email: "invalid@email.com"}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email:"invalid@email.com")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_path
    user.toggle!(:activated)
    # Invalid reset token
    get edit_password_reset_path("invalid token", email: user.email)
    assert_redirected_to root_path
    # Correct token, correct email
    get edit_password_reset_url(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password and confirmation
    patch password_reset_path(user.reset_token),
          params: {email: user.email, user:{
                  password:              "pass123",
                  password_confirmation: "other_pass"}}
    assert_select "div#error_explanation"
    # Empty password
    patch password_reset_path(user.reset_token),
          params: {email: user.email,
                  user:{password:"", password_confirmation:""}}
    assert_select "div#error_explanation"
    # Valid email and password
    patch password_reset_path(user.reset_token),
            params: {email: user.email,
                    user:{password:"pass123", password_confirmation: "pass123"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
    user.reload
    assert_nil user.reset_digest
  end

  test 'expired token' do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: {email: @user.email}}
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), params: {email: @user.email,
                  user:{ password: "pass123", password_confirmation: "pass123"}}
    assert_redirected_to new_password_reset_path
    follow_redirect!
    assert_match "Password has expired", response.body
  end

end
