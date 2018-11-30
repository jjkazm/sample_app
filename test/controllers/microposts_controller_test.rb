require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:apple)
    @user1 = users(:jurek)
    @user2 = users(:agatka)
  end

  test "should redirect create if not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: "Lorem ipsum"}}
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path (@micropost)
    end
    assert_redirected_to login_path
  end

  test "user can't delete posts of other users" do
    log_in_as @user2
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url
  end

  test 'user can delete his own posts' do
    log_in_as @user1
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url
  end
end
