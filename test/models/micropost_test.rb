require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:jurek)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'micropost need to have user id' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'micropost should have contet' do
    @micropost.content = ""
    assert_not @micropost.valid?
  end

  test "microposts content can't be longer than 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test 'order should be most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
