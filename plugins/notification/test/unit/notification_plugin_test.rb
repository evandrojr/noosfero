require File.dirname(__FILE__) + '/../test_helper'

class NotificationPluginTest < ActiveSupport::TestCase

  should "add notification content for content types" do 
    notification = NotificationPlugin.new
    assert  notification.content_types.include?(NotificationPlugin::NotificationContent)
  end

  should "add lobby notes content for content types" do 
    notification = NotificationPlugin.new
    assert  notification.content_types.include?(NotificationPlugin::LobbyNoteContent)
  end

end
