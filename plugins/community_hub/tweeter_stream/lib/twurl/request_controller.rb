require "json"
require 'iconv'

module Twurl
  class RequestController < AbstractCommandController
    NO_URI_MESSAGE = "No URI specified"

    def dispatch
      if client.needs_to_authorize?
        raise Exception, "You need to authorize first."
      end
      options.path ||= OAuthClient.rcfile.alias_from_options(options)
      perform_request
    end

    def perform_request
      client.perform_request_from_options(options) { |response|
          chunk_begining = ""
          puts "Connecting to tweeter stream: " + response.inspect
          response.read_body {   |chunk|
            chunk = chunk_begining + chunk
            chunk_complete = false
            unless chunk.blank?
               begin
                parsed = JSON.parse(chunk)
                chunk_complete = true
                chunk_begining = ""
              rescue JSON::ParserError => e
                chunk_begining = chunk
                chunk_complete = false
              end
              begin
                if chunk_complete
                  ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
                  #Attention please, don't remove + ' ')[0..-2] it is used for UTF8 validation
                  comment_text = ic.iconv(parsed["text"] + ' ')[0..-2]
                  comment = Comment.new
                  comment.title = 'hub-message-twitter'
                  comment.source = options.page
                  comment.body = comment_text
                  comment.author_id = options.author_id
                  #Attention please, don't remove + ' ')[0..-2] it is used for UTF8 validation               
                  comment.name = ic.iconv(parsed["user"]["name"] + ' ')[0..-2]
                  comment.email = 'admin@localhost.local'
                  comment.save!
                  puts "@#{comment.name} " +_('said') + ": #{comment_text}"
                end
              rescue => e
                puts "Erro gravando comentário twitter #{e.inspect}"
              end
            end
          }
      }
      rescue URI::InvalidURIError
        Stream.puts NO_URI_MESSAGE
      end
  end
end