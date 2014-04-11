module Twurl
  class Stream
    
    SUPPORTED_COMMANDS     = %w(authorize accounts alias set)
    DEFAULT_COMMAND        = 'request'
    PATH_PATTERN           = /^\/\w+/
    PROTOCOL_PATTERN       = /^\w+:\/\//
    README                 = File.dirname(__FILE__) + '/../../README'
    @output              ||= STDOUT
    class NoPathFound < Exception
    end

    class << self
      attr_accessor :output

      def run(tags, config_file_path, proxy=nil)
        begin
            @@file_path = config_file_path
            Twurl.options         = Options.new
            Twurl.options.command = 'request' # Not necessary anymore
            Twurl.options.data = {"track"=>tags}
#           Twurl.options.proxy = 'http://161.148.1.167:312' # Use for production mode at SERPRO           
            Twurl.options.proxy = proxy unless proxy.nil?
            Twurl.options.trace   = false
            Twurl.options.headers = {}
            Twurl.options.subcommands=[]
            Twurl.options.upload  = {}
            Twurl.options.upload['file'] = []      
            Twurl.options.path="/1.1/statuses/filter.json"
            Twurl.options.host="stream.twitter.com"
            Twurl.options.read_timeout= 0
        rescue NoPathFound => e
          exit
        end
        dispatch(Twurl.options)
      end
      
      def file_path
        @@file_path
      end

      def dispatch(options)
        client     = OAuthClient.load_from_options(options)
        controller = RequestController
        controller.dispatch(client, options)
      rescue Twurl::Exception => exception
        abort(exception.message)
      end

      def output
        if Twurl.options && Twurl.options.output
          Twurl.options.output
        else
          @output
        end
      end

      def print(*args, &block)
        output.print(*args, &block)
        output.flush if output.respond_to?(:flush)
      end

      def puts(*args, &block)
        output.puts(*args, &block)
        output.flush if output.respond_to?(:flush)
      end

      def prompt_for(label)
        system "stty -echo"
        CLI.print "#{label}: "
        result = STDIN.gets.chomp
        CLI.puts
        result
      rescue Interrupt
        exit
      ensure
        system "stty echo"
      end

      private
        def extract_command!(arguments)
          if SUPPORTED_COMMANDS.include?(arguments.first)
            arguments.shift
          else
            DEFAULT_COMMAND
          end
        end

        def extract_path!(arguments)
          path = nil
          arguments.each_with_index do |argument, index|
            if argument[PATH_PATTERN]
              path_with_params = arguments.slice!(index)
              path, params = path_with_params.split("?", 2)
              if params
                path += "?" + escape_params(params)
              end
              break
            end
          end
          path
        end

        def escape_params(params)
          split_params = params.split("&").map do |param|
            key, value = param.split('=', 2)
            CGI::escape(key) + '=' + CGI::escape(value)
          end
          split_params.join("&")
        end
    end
  end

    
  class Options < OpenStruct
    DEFAULT_REQUEST_METHOD = 'get'
    DEFAULT_HOST           = 'api.twitter.com'
    DEFAULT_PROTOCOL       = 'https'

    def oauth_client_options
      OAuthClient::OAUTH_CLIENT_OPTIONS.inject({}) do |options, option|
        options[option] = send(option)
        options
      end
    end

    def base_url
      "#{protocol}://#{host}"
    end

    def ssl?
      protocol == 'https'
    end

    def debug_output_io
      super || STDERR
    end

    def request_method
      super || (data.empty? ? DEFAULT_REQUEST_METHOD : 'post')
    end

    def protocol
      super || DEFAULT_PROTOCOL
    end

    def host
      super || DEFAULT_HOST
    end

    def proxy
      super || nil
    end
  end
end
