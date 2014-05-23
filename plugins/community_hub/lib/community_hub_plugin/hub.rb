require File.dirname(__FILE__) + '/../../twitter/stream.rb'
require File.dirname(__FILE__) + '/../../facebook_stream/lib_facebook_stream'

class CommunityHubPlugin::Hub < Folder

  attr_accessible :last_changed_by_id, :integer

  attr_accessible :twitter_enabled, :type => :booelan, :default => false
  attr_accessible :twitter_hashtags, :type => :string, :default => ""
  attr_accessible :twitter_consumer_key, :type => :string, :default => ""
  attr_accessible :twitter_consumer_secret, :type => :string, :default => ""
  attr_accessible :twitter_access_token, :type => :string, :default => ""
  attr_accessible :twitter_access_token_secret, :type => :string, :default => ""

  settings_items :twitter_enabled, :type => :boolean, :default => false
  settings_items :twitter_hashtags, :type => :string, :default => ""
  settings_items :twitter_consumer_key, :type => :string, :default => ""
  settings_items :twitter_consumer_secret, :type => :string, :default => ""
  settings_items :twitter_access_token, :type => :string, :default => ""
  settings_items :twitter_access_token_secret, :type => :string, :default => ""
  settings_items :facebook_enabled, :type => :boolean, :default => false
  settings_items :facebook_hashtag, :type => :string, :default => ""
  settings_items :facebook_pooling_time, :type => :integer, :default => 5 # Time in seconds
  settings_items :facebook_access_token,  :type => :string, :default => ''
  settings_items :pinned_messages, :type => Array, :default => []
  settings_items :pinned_mediations, :type => Array, :default => []
  settings_items :mediators, :type => Array, :default => []

  before_create do |hub|
    hub.mediators = [hub.author.id]
  end

  def notify_comments
    false
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

  def mediator?(user)
    self.author.id == user.id || self.mediators.include?(user.id) ? true : false
  end
end
