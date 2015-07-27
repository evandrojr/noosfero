# A Distributed Cache Store is needed
# to save oauth autenthication to be
# used on OAUTH flow using the Noosfero REST API.
# Because of the nature session less of api implementation
# When using more than one server is strongly recomended
# provide your Rails application with a distributed Cache Store,
# otherwise you will have to rely on client/server affinify provided by
# network infrastructure
class OauthClientPlugin::SignupDataStore

    def self.key_name_for email, signup_token
      "#{email}_#{signup_token}"
    end

    def self.get_oauth_data email, signup_token
      key_name = key_name_for(email, signup_token)
      puts "OAUTH_KEY_NAME :::: #{key_name}"
      oauth_data = Rails.cache.fetch(key_name)
      Rails.cache.delete(key_name)
      oauth_data
    end

    def self.store_oauth_data email, auth_obj
      signup_token = SecureRandom.hex
      Rails.cache.write(key_name_for(email, signup_token), auth_obj, :expires_in => 300)
      signup_token
    end

    def self.delete_cache_for email
      Rails.cache.delete(cache_name_for(email))
    end


end
