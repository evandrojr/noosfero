require 'rubygems'
require 'koala'
require 'json'

#Warning!!!  Warning!!!  Warning!!!  Warning!!!  Warning!!!  Warning!!!  Warning!!!  Warning!!!
#token will expire at 12/04/2014 (Brazilian date format) + 59 days
#'CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH'
# BACKUP TOKEN 'CAAEhsewl0ZAcBAHhipXszZCURSwWLmgvceDbs9mB5baJdLriFxYMEzywmF2fvZBuThuA2Mm7QF8wPd3E6R5pVqVEnC2VhcBb4VrfAnkZC73ZC5g1NRUnKZCB2e6CaRiUBDatR2nf505PeKp7Aj5XxvTdfSqdZCsXxQFYZApPNSUUgkUWm6HwL4rp21MRJXb612sZD'

def deprecated_facebook_comments(hub, author_id, page_id, pooling_time, token, proxy_url)
  pooling_time ||= 5
  Koala.http_service.http_options = { :proxy => proxy_url } unless proxy_url.blank?

  @graph = Koala::Facebook::API.new(token)
  initialComments = []
  firstTime = true
  while true
    feed = @graph.get_connections(page_id, "posts")
    array = []
    extractedComments = []
    feed.each {|f|
      if f['comments'] != nil && f['comments']['data'] != nil
        array.push(f['comments']['data'])
      end
    }
    extractedComments = array.flatten.uniq
    if firstTime
      initialComments = extractedComments.clone
      firstTime = false
    end
    newComments =  extractedComments - initialComments
    newComments = newComments.uniq
    initialComments += newComments
    initialComments = initialComments.uniq
    newComments.each{|comment|
      puts "#{comment['from']['name']} " + _("said")  + ": #{comment['message']}"
      noosferoComment = Comment.new
      noosferoComment.title = 'hub-message-facebook'
      noosferoComment.source = hub
      noosferoComment.body = comment['message']
      noosferoComment.author_id = author_id
      noosferoComment.name = comment['from']['name']
      noosferoComment.email = 'admin@localhost.local'
      noosferoComment.save!
    }
    sleep(pooling_time)
  end
end
