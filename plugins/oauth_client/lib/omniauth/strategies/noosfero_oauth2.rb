require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class NoosferoOauth2 < OmniAuth::Strategies::OAuth2
      option :name, :noosfero_oauth2

      uid { raw_info["id"] }

      info do
        {
          :email => raw_info["email"]
        }
      end

      def raw_info
        #FIXME access the noosfero api (coming soon)
        @raw_info ||= access_token.get('/plugin/oauth_provider/public/me').parsed
      end
    end
  end
end
