require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
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
end
