require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jurek)
    log_in_as @user
  end

  test 'following page' do
    get following_user_path(@user)
    assert_not @user.followees.empty?
    assert_match @user.followees.count.to_s, response.body
    @user.followees.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test 'followers page' do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

end
