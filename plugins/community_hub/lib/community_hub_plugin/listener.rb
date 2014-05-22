require 'ftools'

class CommunityHubPlugin::Listener

  class << self

    def twitter_service(hub)
      listen_twitter_stream(hub, nil)
    end

    def facebook_service(hub)
      facebook_comments(hub, nil, hub.facebook_page_id, hub.facebook_pooling_time, hub.facebook_access_token, hub.proxy_url)
    end

    def run
      hubs = {}
      loop do
        log "searching for hubs"
        CommunityHubPlugin::Hub.all.each do |hub|
          hub_conf = hubs[hub.id]
          if hub_conf.nil? || hub_conf[:hub].updated_at < hub.updated_at
            hub_conf[:threads].each {|t| t.terminate} if hub_conf
            log "hub #{hub.id} found!!!!!!"
            threads = []
            threads << Thread.new { twitter_service(hub) } if hub.twitter_enabled
            threads << Thread.new { facebook_service(hub) } if hub.facebook_enabled
            hubs[hub.id] = {:threads => threads, :hub => hub}
          end
        end
        sleep(10)
      end
    end

    def initialize_logger
      logdir = File.join(Rails.root, 'log', CommunityHubPlugin::Listener.name.underscore)
      FileUtils.makedirs(logdir) if !File.exist?(logdir)
      logpath = File.join(logdir, "#{ENV['RAILS_ENV']}_#{Time.now.strftime('%F')}.log")
      @logger = Logger.new(logpath)
    end

    def log(message)
      initialize_logger unless @initiated
      @initiated ||= true
      @logger << "[#{Time.now.strftime('%F %T %z')}] #{message}\n"
    end

  end

end
