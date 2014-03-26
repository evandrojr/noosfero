class OauthClientPlugin < Noosfero::Plugin

  def self.plugin_name
    "Oauth Client Plugin"
  end

  def self.plugin_description
    _("Login with Oauth.")
  end

  def login_extra_contents
    plugin = self
    proc do
      render :partial => 'auth/oauth_login', :locals => {:providers => plugin.enabled_providers}
    end
  end

  def signup_extra_contents
    plugin = self

    proc do
      unless (plugin.context.params[:user]||{})[:oauth_providers].blank?
        render :partial => 'oauth_signup'
      else
        ''
      end
    end
  end

  def enabled_providers
    settings = Noosfero::Plugin::Settings.new(context.environment, OauthClientPlugin)
    providers = settings.get_setting(:providers)
    providers.select {|provider, options| options[:enabled]}
  end

  PROVIDERS = {
    :facebook => {
      :name => 'Facebook'
    },
    :google_oauth2 => {
      :name => 'Google'
    }
  }

  def stylesheet?
    true
  end

  Rails.application.config.middleware.use OmniAuth::Builder do
    PROVIDERS.each do |provider, options|
      provider provider, :setup => lambda { |env|
        request = Rack::Request.new env
        strategy = env['omniauth.strategy']

        domain = Domain.find_by_name(request.host)
        environment = domain.environment rescue Environment.default
        settings = Noosfero::Plugin::Settings.new(environment, OauthClientPlugin)
        providers = settings.get_setting(:providers)

        strategy.options.client_id = providers[provider][:client_id]
        strategy.options.client_secret = providers[provider][:client_secret]
      }, :path_prefix => '/plugin/oauth_client', :callback_path => "/plugin/oauth_client/public/callback/#{provider}"
    end

    unless Rails.env.production?
      provider :developer, :path_prefix => "/plugin/oauth_client", :callback_path => "/plugin/oauth_client/public/callback/developer"
    end
  end

end
