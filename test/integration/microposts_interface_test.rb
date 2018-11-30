require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = users(:jurek)
    @user2 = users(:agatka)
    @user3 = users(:user_1)
  end

  test 'micropost interface' do
    log_in_as @user1
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Unsuccesfull post
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "" }}
    end
    assert_template 'static_pages/home'
    assert_select 'div#error_explanation'
    #succesfull post
    content = "new test post"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture}}
    end
    post = assigns(:micropost)
    # below lines ared uplicated in order to try both ways of asserting picture
    assert post.picture?
    assert @user1.microposts.first.picture?
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'span.content', text: content
    # Delete post
    assert_difference "Micropost.count", -1 do
      delete micropost_path(@user1.microposts.first)
    end
    # No delete links for other user's profile
    get user_path (@user2)
    assert_match @user2.name, response.body
    assert_select 'a', text: 'Delete', count: 0
  end

  test 'micropost sidebar count' do
    log_in_as @user1
    get root_path
    assert_match "#{@user1.microposts.count} microposts", response.body
    # User with zero posts
    log_in_as @user3
    get root_path
    assert_match "0 microposts", response.body
    @user3.microposts.create!(content: "A micropost")
    get root_path
    assert_match @user3.microposts.first.content, response.body
  end
end
