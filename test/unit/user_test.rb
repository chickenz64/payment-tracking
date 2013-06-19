require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User group relation" do
    one_to_many_relations(:user,:group,:destroy)
  end
  test "User client relation" do
    one_to_many_relations(:user,:client,:destroy)
  end
  test "User product relation" do
    one_to_many_relations(:user,:product,:destroy)
  end
  test "User plans relation" do
    one_to_many_relations(:user,:plan,:destroy)
  end
end
