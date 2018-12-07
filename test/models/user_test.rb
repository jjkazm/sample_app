require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Kuba", email: "kuba@wp.pl", password:"haslo1", password_confirmation: "haslo1")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 250 + "@wp.pl"
    assert_not @user.valid?
  end

  test "email validation should accept valid emails" do
    valid_emails = %w[ agatka2@wp.pl jj@gmail.com jurandoo@yahoo.co.uk patek@paptek.cz]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "email validation should reject invalid emails" do
    invalid_emails = %w[ wp@_.pl @kutek.pl kutek@pl pas@ jjkazm@wp,pl jjkazm@gmai_l.com foo@bar..com]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be rejected"
    end
  end

  test "email should be unique" do
    dup_user = @user.dup
    @user.save
    dup_user.email = dup_user.email.upcase
    assert_not dup_user.valid?
  end

  test "email should be saved as downcase" do
    upcase_email = "UPCASE@wp.pl"
    @user.email = upcase_email
    @user.save
    assert_equal upcase_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = "   "
    assert_not @user.valid?
  end

  test "password should not be to short" do
    @user.password = @user.password_confirmation = "q" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for user with nil remember_token" do
    assert_not @user.authenticated?(:remember, 'some_random_token')
  end

  test 'associated micropost should be destroyed' do
    @user.save
    @user.microposts.create(content: "Best post in the world")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow user' do
    jurek = users(:jurek)
    agatka = users(:agatka)
    assert_not agatka.following?(jurek)
    agatka.follow(jurek)
    assert agatka.following?(jurek)
    assert jurek.followers.include?(agatka)
    agatka.unfollow(jurek)
    assert_not agatka.following?(jurek)
  end

  test 'should inculde relevant microposts in feed' do
    jurek = users(:jurek)
    agatka = users(:agatka)
    kuba = users(:kuba)

    # includes posts from followed user
    agatka.microposts.each do |post|
      assert jurek.feed.include?(post)
    end

    # includes own microposts
    jurek.microposts.each do |post|
      assert jurek.feed.include?(post)
    end

    # doesn't contain microposts of not followed users
    kuba.micropostss.each do |post|
      assert_not jurek.feed.include?(post)
    end
  end
end
