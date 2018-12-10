require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jurek)
    @user2 = users(:user_1)
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

  test 'should follow user in regular way' do
    assert_difference '@user2.followers.count', 1 do
      post relationships_path, params: {followed_id: @user2.id}
    end
  end

  test 'should follow user in Ajax way' do
    assert_difference '@user2.followers.count', 1 do
      post relationships_path, params: {followed_id: @user2.id}, xhr: true
    end
  end

  test 'should unfollow user in regular way' do
    @user.follow(@user2)
    relationship = @user2.passive_relationships.find_by(follower_id: @user.id)
    assert_difference '@user2.followers.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'should unfollow user in Ajax way' do
    @user2.follow(@user)
    rel = @user2.active_relationships.find_by(followed_id: @user.id)
    assert_difference '@user.followers.count', -1 do
      delete relationship_path(rel), xhr: true
    end
  end

  test 'feed on Home page' do
    get root_path
    @user.feed.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
  end

end
