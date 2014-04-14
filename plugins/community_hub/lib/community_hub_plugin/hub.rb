require File.dirname(__FILE__) + '/../../tweeter_stream/lib/twurl'
require File.dirname(__FILE__) + '/../../facebook_stream/lib_facebook_stream'

class CommunityHubPlugin::Hub < Folder

  settings_items :hashtags_twitter, :type => :string, :default => ""
  settings_items :promoted_users, :type => Array, :default => []
  settings_items :pinned_posts, :type => Array, :default => []

 @@twitter_thread_started = false
 @@facebook_thread_started = false
  
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
      action=:start
      if action==:start 
        thread = Thread.new {
           Twurl::Stream.run(page, author_id,'torrent', File.dirname(__FILE__) + '/../../tweeter_stream/config/.twurlrc')
        } unless@@twitter_thread_started
       @@twitter_thread_started = true
      end
  end
  
  def self.facebook_service(page, action)
      action=:start
      page_id="mundoreagindo"
      if action==:start 
        thread = Thread.new {
           #facebook_comments(page, author_id, page_id, pooling_time=5, token='CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH')          
#           raise "entrou".inpect
           facebook_comments(page, author_id, page_id)
        } unless@@facebook_thread_started
       @@facebook_thread_started = true
      end
  end


  
  def view_page
    "content_viewer/hub.rhtml"
  end

end