require File.dirname(__FILE__) + '/../../tweeter_stream/lib/twurl'


class CommunityHubPlugin::Hub < Folder

  settings_items :hashtags_twitter, :type => :string, :default => ""
  settings_items :promoted_users, :type => Array, :default => []
  settings_items :pinned_posts, :type => Array, :default => []

  @@thread_started = false
  
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

  def self.start_twitter_service(page)
    
      a = Thread.new { 
         Twurl::Stream.run(page, 'nba', '/root/.twurlrc')
      } unless @@thread_started
      
      @@thread_started = true

#     raise page.inspect 
    
#      comment = Comment.new
#      comment.source_id = page.id
#      comment.body = "Teste Evandro"
#      comment.author_id = "54"
#      comment.save!
      
      
#    raise "Pai #{parent.id}".inspect
    
  end
  
  def view_page
    "content_viewer/hub.rhtml"
  end

end