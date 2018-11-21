require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
    @admin = users(:jurek)
    @user = users(:agatka)
    @user2 = users(:user_1)

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

  test 'not logged visitor can not delete users and is redirected to login page' do
    assert_no_difference 'User.count' do
      delete user_path(@user2)
    end
    assert_redirected_to login_path
  end

  test 'non-admin user can not delete users and ir redirected to home page' do
    log_in_as @user
    assert_no_difference 'User.count' do
      delete user_path(@user2)
    end
    assert_redirected_to root_path
  end

  test 'admin can succesfully delete users' do
    log_in_as @admin
    assert_difference 'User.count', -1 do
      delete user_path(@user2)
    end
    assert_redirected_to users_path
  end

end
