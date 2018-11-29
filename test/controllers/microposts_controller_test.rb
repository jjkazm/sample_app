require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:apple)
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
end