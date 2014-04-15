require 'rubygems'
require 'koala'
require 'json'

#Warning!!!  Warning!!!  Warning!!!  Warning!!!  Warning!!!  Warning!!!  Warning!!!  Warning!!!
#token will expire at 12/04/2014 (Brazilian date format) + 59 days
#'CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH'
# BACKUP TOKEN 'CAAEhsewl0ZAcBAHhipXszZCURSwWLmgvceDbs9mB5baJdLriFxYMEzywmF2fvZBuThuA2Mm7QF8wPd3E6R5pVqVEnC2VhcBb4VrfAnkZC73ZC5g1NRUnKZCB2e6CaRiUBDatR2nf505PeKp7Aj5XxvTdfSqdZCsXxQFYZApPNSUUgkUWm6HwL4rp21MRJXb612sZD'

def facebook_comments(hub, author_id, page_id, pooling_time, token, proxy_url)
  if pooling_time == nil
    pooling_time = 5 
  end  
  @graph = Koala::Facebook::API.new(token)
  initialComments = []
  extractedComments = []
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
      array.each{ |comments|
        comments.each{|comment|
          extractedComments.push("#{comment['from']['name']} " + _("said")  + ": #{comment['message']}")
        }					
      }
      extractedComments = extractedComments.uniq
      if firstTime
        initialComments=extractedComments.clone
        firstTime = false
      end
      newComments =  extractedComments - initialComments
      newComments = newComments.uniq
      initialComments += newComments
      initialComments = initialComments.uniq
      newComments.each{|comment|
                puts comment
                noosferoComment = Comment.new
                noosferoComment.title = 'hub-message-facebook'                                
                noosferoComment.source_id = hub.id
                noosferoComment.body = comment
                noosferoComment.author_id = author_id
                noosferoComment.save!             
      }
      sleep(pooling_time)
    end
end