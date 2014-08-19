class NotificationPlugin < Noosfero::Plugin

  def self.plugin_name
    "Notification Plugin"
  end

  def self.plugin_description
    _("A plugin that add a new content type called notification where a communitty adminsitrator could notify community .")
  end

  def content_types
    [NotificationPlugin::NotificationContent, NotificationPlugin::LobbyNoteContent]
  end

end
