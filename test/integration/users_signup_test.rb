require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

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
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'
    assert is_logged_in?
  end
end
