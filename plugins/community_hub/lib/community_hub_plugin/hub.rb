class CommunityHubPlugin::Hub < Folder

  def self.icon_name(article = nil)
    'community-hub'
  end

  def self.short_description
    _("Hub")
  end

  def self.description
    _('Defines a hub.')
  end

  def view_page
    "content_viewer/hub.rhtml"
  end

  def bli
    "bli"
  end

  def accept_comments?
    true
  end

end