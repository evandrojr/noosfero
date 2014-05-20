require File.dirname(__FILE__) + '/../../test_helper'

class HubHelperTest < ActiveSupport::TestCase

  include CommunityHubPlugin::HubHelper
  include NoosferoTestHelper

  should 'return time formated to hh:mm' do
    t = Time.utc(2014,"jan",1,17,40,0)
    assert_equal post_time(t), "17:40"
  end

  should 'return empty string if param is not time' do
    i = 1
    assert_equal post_time(i), ''
  end

end
