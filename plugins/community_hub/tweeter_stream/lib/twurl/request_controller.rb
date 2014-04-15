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
#           print "#{chunk}\n"
            #unless chunk.to_i.length = 0 
              begin
                parsed = JSON.parse(chunk)
                ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
                comment_text = ic.iconv("@#{parsed["user"]["name"]} " + _('said') + ": #{parsed["text"]}" + ' ')[0..-2]
                print "#{comment_text}\n"
                comment = Comment.new
                comment.source_id = Stream.page.id
                comment.body = comment_text
                comment.author_id = Stream.author_id
                comment.save!     
              rescue
                print "Erro gravando comentário twitter\n"
              end  
                #raise comment.inspect
#              rescue
#              end
            #end  
          }
      }
    rescue URI::InvalidURIError
      Stream.puts NO_URI_MESSAGE
    end
  end
end
