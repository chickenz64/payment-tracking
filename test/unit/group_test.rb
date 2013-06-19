require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "Group client relation" do
    one_to_many_relations(:group,:client,:nullify)
  end
end
