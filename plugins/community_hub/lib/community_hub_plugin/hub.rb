class CommunityHubPlugin::Hub < Folder

  settings_items :hashtags_twitter, :type => :string, :default => ""

  def self.icon_name(article = nil)
    'community-hub'
  end

  def self.short_description
    _("Hub")
  end

  def self.description
    _('Defines a hub.')
  end

  def accept_comments?
    true
  end

  def view_page
    "content_viewer/hub.rhtml"
  end

end