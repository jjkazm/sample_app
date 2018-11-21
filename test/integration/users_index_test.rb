require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @admin = users(:jurek)
    @user = users(:agatka)
  end

  test "index including pagination when logged as user" do
    log_in_as @admin
    get users_path
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user.admin == true
        assert_select 'a[href=?]', user_path(user), method: :delete
      end
    end
  end

  test "index for non-admins" do
    log_in_as @user
    get users_path
      assert_select 'a', text: "Delete", count: 0
  end
end
