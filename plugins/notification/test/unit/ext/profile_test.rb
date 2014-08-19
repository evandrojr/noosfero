require File.dirname(__FILE__) + '/../../test_helper'

class ProfileTest < ActiveSupport::TestCase

  should "comunity have notifications method defined" do 
    profile = Community.new
    assert_nothing_raised do 
      profile.notifications
    end
  end

  should "comunity have lobby_notes method defined" do 
    profile = Community.new
    assert_nothing_raised do 
      profile.lobby_notes
    end
  end

end
