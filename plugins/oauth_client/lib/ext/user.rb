require_dependency 'user'

class User

  has_many :oauth_auths, through: :person
  has_many :oauth_providers, through: :oauth_auths, source: :provider

  after_create :activate_oauth_user

  def activate_oauth_user
    self.activate if oauth_providers.present?
  end

  def password_required_with_oauth?
    # user creation through api does not set oauth_providers
    check_providers
    password_required_without_oauth? && oauth_providers.empty?
  end

  def oauth_data
    @oauth_data
  end

  def oauth_signup_token= value
    @oauth_signup_token = value
  end

  def oauth_signup_token
    @oauth_signup_token
  end

  alias_method_chain :password_required?, :oauth

  after_create :activate_oauth_user

  # user creation through api does not set oauth_providers
  # so it is being shared through a distributed cache
  def check_providers
    if oauth_providers.empty? && oauth_signup_token.present?
      #check if is oauth user, reading oauth_data recorded at cache store
      @oauth_data = OauthClientPlugin::SignupDataStore.get_oauth_data(self.email, self.oauth_signup_token)
      if @oauth_data
        provider_id = @oauth_data.delete(:provider_id)
        self.oauth_providers = [OauthClientPlugin::Provider.find(provider_id)]
      end
    end
  end

  def activate_oauth_user
    self.oauth_providers.each do |provider|
      OauthClientPlugin::Auth.create! do |user_provider|
        user_provider.profile = self.person
        user_provider.provider = provider
        user_provider.enabled = true
        user_provider.oauth_data = oauth_data
      end
    end
    activate unless oauth_providers.empty?
  end

  def make_activation_code_with_oauth
    self.oauth_providers.blank? ? make_activation_code_without_oauth : nil
  end

  alias_method_chain :make_activation_code, :oauth

end
