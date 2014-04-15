require File.dirname(__FILE__) + '/../../tweeter_stream/lib/twurl'
require File.dirname(__FILE__) + '/../../facebook_stream/lib_facebook_stream'

class CommunityHubPlugin::Hub < Folder

 @@twitter_thread_started = false #change to hash
 @@facebook_thread_started = false #change to hash

  settings_items :proxy_url, :type => :string, :default => 'http://161.148.1.167:312' # Remember to use add the port, if needed!      
  settings_items :twitter_enabled, :type => :boolean, :default => false  
  settings_items :hashtags_twitter, :type => :string, :default => "participa.br,participabr,arenanetmundial,netmundial" 
  settings_items :facebook_enabled, :type => :boolean, :default => false
  settings_items :facebook_page_id, :type => :string, :default => "participabr"  
  settings_items :facebook_pooling_time, :type => :integer, :default => 5 # Time in seconds  
  settings_items :facebook_access_token,  :type => :string, :default => 'CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH'    
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

  def self.twitter_service(hub, action)
    #raise hub.inspect
      #if self.twitter_enabled == false
      author_id = 54
      if action==:start 
        thread = Thread.new {
           Twurl::Stream.run(hub, author_id, self.hashtags_twitter, File.dirname(__FILE__) + '/../../tweeter_stream/config/twurlrc', self.proxy_url)
       } unless@@twitter_thread_started
       @@twitter_thread_started = true
      end
  end
  
  def self.facebook_service(hub, action)
      author_id = 54
      page_id="mundoreagindo"
      if action==:start 
       #facebook_comments(page, author_id, page_id, pooling_time=5, token='CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH')          
       thread = Thread.new {
           facebook_comments(hub, author_id, self.facebook_page_id, self.pooling_time, self.facebook_access_token, self.proxy_url)
       } unless@@facebook_thread_started
       @@facebook_thread_started = true
      end
  end
  
  def view_page
    "content_viewer/hub.rhtml"
  end
end
