require "json"

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
#            print "#{chunk}\n"
            #unless chunk.to_i.length = 0 
              begin
                parsed = JSON.parse(chunk)
#                print "@#{parsed["user"]["name"]} said: #{parsed["text"]}  \n"
                comment = Comment.new
                comment.source_id = Stream.page.id
                comment.body = parsed["text"]
                comment.author_id = "54"
                comment.save!     
              rescue
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
