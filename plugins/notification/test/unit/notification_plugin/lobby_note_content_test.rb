require File.dirname(__FILE__) + '/../../test_helper'

class NotificationPlugin::LobbyNoteContentTest < ActiveSupport::TestCase

  should 'create the content type lobby note' do
    assert_nothing_raised NameError do
      note = LobbyNoteContent.new
    end
  end

end
