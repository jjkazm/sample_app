require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
    @user = users(:jurek)
  end
  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
  end

  test 'should redirect to login when attempting index page without login' do
    get users_path
    assert_redirected_to login_path
  end

  test 'should not let update admin value in user' do
    log_in_as @user
    patch user_path @user, params: {user: { name: "Jurand", email: "jurek@wp.pl",
                                password: "haslo1", password_confirmation: "haslo1",
                                admin: true}}
    @user.reload
    assert_not @user.admin?
  end

end
