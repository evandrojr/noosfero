require_dependency 'profile'

Profile.class_eval do
  has_many :notifications, :source => 'articles', :class_name => 'NotificationPlugin::NotificationContent', :order => 'start_date'
  has_many :lobby_notes, :source => 'articles', :class_name => 'NotificationPlugin::LobbyNoteContent', :order => 'start_date'
end

Person.class_eval do
#  has_many :notifications, :source => 'articles', :class_name => 'NotificationPlugin::NotificationContent', :order => 'start_date'
  has_many :lobby_notes, :foreign_key => 'created_by_id', :class_name => 'NotificationPlugin::LobbyNoteContent', :order => 'start_date,created_at'
#  named_scope :lobby_notes_by_profile
end

