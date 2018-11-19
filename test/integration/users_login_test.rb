require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:jurek)
  end

  test 'failed login with invalid credentials' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: "invalid",
                                        password: "invalid"}}
    assert_template 'sessions/new'
    assert_select 'div.alert.alert-danger'
    get root_path
    assert_select 'div.alert.alert-danger', false
  end

  test 'successful login with valid credentials followed by logout' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: @user.email,
                                        password: "haslo1" }}
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert !is_logged_in?
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", logout_path, count: 0

    # Simulate logout from second browser
    delete logout_path
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end
end
