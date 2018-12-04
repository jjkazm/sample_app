require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:jurek).id,
                                      followed_id: users(:agatka).id)
  end

  test 'relationship must have follower' do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test 'relationship must have followed' do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test 'correct relationship should be valid' do
    assert @relationship.valid?
  end
end
