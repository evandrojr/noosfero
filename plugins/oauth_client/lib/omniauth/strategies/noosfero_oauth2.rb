require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class NoosferoOauth2 < OmniAuth::Strategies::OAuth2
      option :name, :noosfero_oauth2

      option :client_options, {
        :site => "http://noosfero.com:3001",
        :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
          :email => raw_info["email"]
          # and anything else you want to return to your API consumers
        }
      end

      def raw_info
        #@raw_info ||= access_token.get('/api/v1/me.json').parsed
        #FIXME
        #raise access_token.inspect
        User['vfcosta'].attributes
      end
    end
  end
end
