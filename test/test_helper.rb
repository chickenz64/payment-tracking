ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  def one_to_many_relations(one, many, dependent)
    one_obj  = FactoryGirl.create(one)
    many_obj = Array.new(3).map!{ FactoryGirl.create(many, one=>one_obj) }
    assert_equal 3, one_obj.try("#{many}s").count
    assert_equal many_obj[0].try(one).id, one_obj.id

    one_class  = one.to_s.split("_").collect(&:capitalize).join.constantize
    many_class = many.to_s.split("_").collect(&:capitalize).join.constantize
    one_class.find(one_obj.id).destroy

    if dependent == :destroy
      assert_equal many_class.where(one=>one_obj.id).count, 0
    elsif dependent == :nullify
      assert_nil many_class.find(many_obj[0].id).try(one)
    end
  end
   # Drop all columns after each test case.
  def teardown
    Mongoid.default_session.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end

  # Make sure that each test case has a teardown
  # method to clear the db after each test.
  def inherited(base)
    base.define_method teardown do
      super
    end
  end
end