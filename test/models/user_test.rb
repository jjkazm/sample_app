require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Kuba", email: "kuba@wp.pl")
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
    valid_emails = %w[ agatka@wp.pl jj@gmail.com jurandoo@yahoo.co.uk patek@paptek.cz]
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
end
