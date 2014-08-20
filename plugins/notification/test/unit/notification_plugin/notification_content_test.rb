require File.dirname(__FILE__) + '/../../test_helper'

class NotificationPlugin::NotificationContentTest < ActiveSupport::TestCase

  should 'create the content type notification' do
    assert_nothing_raised NameError do
      notification = NotificationContent.new
    end
  end

end
