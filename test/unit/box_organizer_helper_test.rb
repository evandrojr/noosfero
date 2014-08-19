# encoding: UTF-8
require File.dirname(__FILE__) + '/../test_helper'

class BoxOrganizerHelperTest < ActiveSupport::TestCase

  include BoxOrganizerHelper

  should 'max number of blocks be 7' do
    assert_equal 7, max_number_of_blocks_per_line
  end

end
