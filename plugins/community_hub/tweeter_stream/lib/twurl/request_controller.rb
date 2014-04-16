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
          response.read_body { |chunk|
            #print "chunk: #{chunk}\n"
            unless chunk.blank?
              begin
                parsed = JSON.parse(chunk)
                ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
                comment_text = ic.iconv(parsed["text"])[0..-2]
                print "#{comment_text}\n"
                comment = Comment.new
                comment.title = 'hub-message-twitter'
                comment.source = options.page
                comment.body = comment_text
                comment.author_id = options.author_id
                comment.name = ic.iconv(parsed["user"]["name"])[0..-2]
                comment.email = 'admin@localhost.local'
                comment.save!
              rescue => e
                print "Erro gravando comentário twitter #{e}\n"
              end
            end
          }
      }
    rescue URI::InvalidURIError
      Stream.puts NO_URI_MESSAGE
    end
  end
end
