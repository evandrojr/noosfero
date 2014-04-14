require File.dirname(__FILE__) + '/../../tweeter_stream/lib/twurl'
require File.dirname(__FILE__) + '/../../facebook_stream/lib_facebook_stream'

class CommunityHubPlugin::Hub < Folder

 @@twitter_thread_started = false #change to hash
 @@facebook_thread_started = false #change to hash
  
  settings_items :hashtags_twitter, :type => :string, :default => ""
  settings_items :twitter_enabled, :type => :boolean, :default => false
  settings_items :facebook_enabled, :type => :boolean, :default => false
  settings_items :pinned_messages, :type => Array, :default => []
  settings_items :pinned_mediations, :type => Array, :default => []
  settings_items :mediators, :type => Array, :default => []

  before_create do |hub|
    hub.mediators = [hub.author.id]
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

  def self.twitter_service(page, action)
      author_id = 54
      if action==:start 
        thread = Thread.new {
           Twurl::Stream.run(page, author_id,'torrent', File.dirname(__FILE__) + '/../../tweeter_stream/config/twurlrc')
       } unless@@twitter_thread_started
       @@twitter_thread_started = true
      end
  end
  
  def self.facebook_service(page, action)
      author_id = 54
      page_id="mundoreagindo"
      if action==:start 
        thread = Thread.new {
           #facebook_comments(page, author_id, page_id, pooling_time=5, token='CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH')          
           facebook_comments(page, author_id, page_id)
        } unless@@facebook_thread_started
       @@facebook_thread_started = true
      end
  end
  
  def view_page
    "content_viewer/hub.rhtml"
  end
end