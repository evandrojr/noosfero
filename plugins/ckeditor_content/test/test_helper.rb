require File.dirname(__FILE__) + '/../../../test/test_helper'

def assert_subclass(parent, child)
  assert_equal parent, child.superclass, "Class #{child} expected to be a subclass of #{parent}"
end
