require 'rubygems'
require 'open-uri'
require 'json'

def not_blank?(v)
  if v == nil || v == ""
    false
  else
    true
  end
end

def save_comment(hub, comment, author_id)
      noosferoComment = Comment.new
      noosferoComment.title = 'hub-message-facebook'
      noosferoComment.source = hub
      noosferoComment.body = comment[:message]
      noosferoComment.author_id = author_id
      noosferoComment.name = comment[:from]
      noosferoComment.email = 'admin@localhost.local'
      noosferoComment.save!  
end


def facebook_comments(hub, author_id, hashtag, pooling_time, token)

  pooling_time ||= 10
  token ||= 'CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH'
  hashtag ||= "#nba"
  #Aviso 12/04/2014
  #token que só deverá expirar em 59 dias
  #https://graph.facebook.com/v1.0/search?q=%23nba&type=post&access_token=CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH
  #
  
  #removes extra '#'
  if hashtag[0,1]=='#'
    hashtag = hashtag[1,hashtag.length-1]
  end

  initialComments = []
  firstTime = true
  read = 1
  url = "https://graph.facebook.com/v1.0/search?q=%23#{hashtag}&type=post&access_token=#{token}"
  mostRecent = ""
  
  while true
    connected = false
    tries = 0
    while !connected
      begin
        tries += 1
        file = open(url)
        connected = true
        tries = 0
      rescue => e
        puts "Error connecting to facebook: #{e.inspect} "
        puts file
        sleep (10 + 2 ** tries)
      end
    end    

    extractedComments = []
    itens = JSON.parse(file.read)['data']
    itens.each{|i|
        from = ""
        message = ""
        if  not_blank?(i['from']['name'])
          from = i['from']['name']
          if not_blank?(i['message'])
            message += i['message']
          else
            if not_blank?(i['description'])
              message += i['description'] 
            else
              if not_blank?(i['caption'])
                message += i['caption']
              end  
            end
          end
          if not_blank?(message)
            if mostRecent == "" or mostRecent < i["created_time"]
              mostRecent = i["created_time"]
            end
            extractedComments.push({:from=>from, :message=>message})
          end
        end
    }
    
    extractedComments = extractedComments.uniq
    if firstTime
      initialComments = extractedComments.clone
      firstTime = false
      extractedComments.each{|comment|
        puts "#{comment[:from]} " + _("said")  + ": #{comment[:message]}"
        save_comment(hub, comment, author_id)
      }      
    end
    
#    if read == 2
#      extractedComments.push({:from=>"Evandro", :message=>"teste"})
#    end
    
    newComments =  extractedComments - initialComments
    newComments = newComments.uniq
    initialComments += newComments
    initialComments = initialComments.uniq
    #y newComments
    newComments.each{|comment|
      puts "#{comment[:from]} " + _("said")  + ": #{comment[:message]}"
      save_comment(hub, comment, author_id)
    }
#    puts url
#    puts "Read: #{read} last post #{mostRecent} newComments: #{newComments.length} initialComments: #{initialComments.length} extractedComments: #{extractedComments.length}"
    read+=1
    sleep(pooling_time)
  end
end