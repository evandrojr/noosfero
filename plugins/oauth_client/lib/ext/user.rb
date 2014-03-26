require_dependency 'user'

class User

  acts_as_having_settings :field => :settings

  settings_items :oauth_providers, :type => Array, :default => []

  def self.find_with_omniauth(auth)
    user = self.find_by_email(auth.info.email)
    if user && !user.oauth_providers.empty? #FIXME save new oauth providers
      user
    else
      nil
    end
  end

  def password_required_with_oauth?
    password_required_without_oauth? && oauth_providers.blank?
  end

  alias_method_chain :password_required?, :oauth

  after_create :activate_oauth_user

  def activate_oauth_user
    activate unless oauth_providers.empty?
  end

  def make_activation_code_with_oauth
    if oauth_providers.blank?
      nil
    else
      make_activation_code_without_oauth
    end
  end

  alias_method_chain :make_activation_code, :oauth

end
