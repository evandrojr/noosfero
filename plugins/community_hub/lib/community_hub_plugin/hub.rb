require File.dirname(__FILE__) + '/../../tweeter_stream/lib/twurl'

class CommunityHubPlugin::Hub < Folder

  settings_items :hashtags_twitter, :type => :string, :default => ""
  settings_items :promoted_users, :type => Array, :default => []
  settings_items :pinned_posts, :type => Array, :default => []

  def initialize(my_var)
    raise "ola".inspect
  end
  
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