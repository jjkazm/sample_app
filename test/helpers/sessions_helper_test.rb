require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:jurek)
    remember(@user)
  end

  test 'current_user returns correct user based on cookie, when session is nil'do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test 'current user is nil, when session is nil and cookie has invalid remember_token' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
