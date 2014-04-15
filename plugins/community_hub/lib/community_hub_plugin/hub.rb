require File.dirname(__FILE__) + '/../../tweeter_stream/lib/twurl'
require File.dirname(__FILE__) + '/../../facebook_stream/lib_facebook_stream'

class CommunityHubPlugin::Hub < Folder

  settings_items :proxy_url, :type => :string, :default => 'http://161.148.1.167:3128' # Remember to use add the port, in case needed.
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

  def twitter_service
    Twurl::Stream.run(self, nil, hashtags_twitter, File.dirname(__FILE__) + '/../../tweeter_stream/config/twurlrc', proxy_url)
  end

  def facebook_service
    facebook_comments(self, nil, facebook_page_id, facebook_pooling_time, facebook_access_token, proxy_url)
  end

  def self.start_listen
    hubs = {}
    loop do
      puts "searching for hubs"
      CommunityHubPlugin::Hub.all.each do |hub|
        hub_conf = hubs[hub.id]
        if hub_conf.nil? || hub_conf[:hub].updated_at < hub.updated_at
          hub_conf[:threads].each {|t| t.terminate} if hub_conf
          puts "hub #{hub.id} found!!!!!!"
          threads = []
          threads << Thread.new { hub.twitter_service } if hub.twitter_enabled
          threads << Thread.new { hub.facebook_service } if hub.facebook_enabled
          hubs[hub.id] = {:threads => threads, :hub => hub}
        end
      end
      sleep(5)
    end
  end

  def view_page
    "content_viewer/hub.rhtml"
  end
end