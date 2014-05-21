require 'rubygems'
require 'open-uri'
require 'json'

token = 'CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH'
hashtag = "#nba"
pooling_time = 5


#Aviso 12/04/2014
#token que só deverá expirar em 59 dias
#@graph = Koala::Facebook::API.new('CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH')
# https://graph.facebook.com/v1.0/search?q=%23nba&type=post&access_token=CAAD8cd4tMVkBAO3sh2DrzwZCDfeQq9ZAvTz7Jz24ZC26KtMfBoljqaXhD2vBV1zpP0bjrpxXUBzJvKKcFzOm6rMG9Sok7iNVUaxt5iwr7dfMqCvHpMboKpqrqgeLrfCH5ITVTAdezA6ZBSr9iOJrqyCSOYfui0zTmbXJ3FqtshwNRrRy4NPH

def not_blank(v)
  if v == nil || v == ""
    false
  else
    true
  end
end

if hashtag[0]='#'
  hashtag = hashtag[1,hashtag.length-1]
end

file = open("https://graph.facebook.com/v1.0/search?q=%23#{hashtag}&type=post&access_token=#{token}")
itens = JSON.parse(file.read)['data']

extractedComments = []
initialComments = []
firstTime = true
while true
  mostRecent = ""
  itens.each{|i|
      from = ""
      message = ""
      if  not_blank(i['from']['name'])
        from = i['from']['name']
        if not_blank(i['message'])
          message += i['message']
        end
        if not_blank(message)
          if mostRecent == "" or mostRecent < i["updated_time"]
            mostRecent = i["updated_time"]
          end
          
          extractedComments.push("#{from} said: #{message}")
         # puts "#{from} said: #{message}"
        end
      end
  }

	extractedComments = extractedComments.uniq
	if firstTime
		initialComments = extractedComments.clone
		firstTime = false
	end

#		extractedComments.each{|comment|
#			 puts comment
#		}					

	newComments =  extractedComments - initialComments
	newComments = newComments.uniq
	initialComments += newComments
	initialComments = initialComments.uniq
	newComments.each{|comment|
		puts comment
	}
  puts "most recent post at #{mostRecent}"
  sleep(pooling_time)
end



