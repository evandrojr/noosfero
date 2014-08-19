require File.dirname(__FILE__) + '/../../test_helper'

class NotificationPlugin::CategoryNotificationTest < ActiveSupport::TestCase

  should 'create the category for notifications' do
    assert_nothing_raised NameError do
      notification = CategoryNotification.new
    end
  end

end
