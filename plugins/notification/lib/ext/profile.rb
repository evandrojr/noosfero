require_dependency 'profile'

Profile.class_eval do
  has_many :notifications, :source => 'articles', :class_name => 'NotificationPlugin::NotificationContent', :order => 'start_date'
  has_many :lobby_notes, :source => 'articles', :class_name => 'NotificationPlugin::LobbyNoteContent', :order => 'start_date'
end
