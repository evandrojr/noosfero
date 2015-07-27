require_dependency 'environment'

class Environment

  has_many :oauth_providers, :class_name => 'OauthClientPlugin::Provider'

  def signup_person_fields_with_oauth
    signup_person_fields_without_oauth + [:oauth_signup_token]
  end

  alias_method_chain :signup_person_fields, :oauth
  
end
