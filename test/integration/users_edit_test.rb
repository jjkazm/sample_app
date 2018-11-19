require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jurek)
  end

  test 'fails with incorrect input' do
    get edit_user_path @user
    assert_template 'users/edit'
    patch user_path, params: {user: {name: "Kuba", email: "", password: "",
                                          password_confirmation: ""}}
    assert_select "div", {class: "alert alert-danger"}
    assert_template 'users/edit'
  end
end
