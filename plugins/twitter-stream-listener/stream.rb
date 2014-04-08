
require 'twitter'
require 'json'

#client = Twitter::REST::Client.new do |config|


client = Twitter::Streaming::Client.new do |config|
    config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
    config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
    config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
end

topics = ["#nba"]

client.filter(:track => topics.join(",")) do |object|
  puts object.to_h.to_json if object.is_a?(Twitter::Tweet)
end



#FACEBOOK

#feed do participa
# precisa do access_token da comunidade participa.br
# com acesso a read_stream
# acessar https://developers.facebook.com/tools/explorer/ e Clicar no botão "Obter token de acesso"
# selecionar na aba Extended Permissions "read_stream"
#https://graph.facebook.com/me/feed?method=GET&format=json&suppress_http_code=1&access_token=ACCESS_TOKEN

# imagem do usuário que postou: 
# http://graph.facebook.com/517267866/picture?type=small
# http://graph.facebook.com/517267866/picture?type=normal
# http://graph.facebook.com/517267866/picture?type=large
# http://graph.facebook.com/517267866/picture?type=square
