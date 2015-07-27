class OauthClientPluginPublicController < PublicController

  skip_before_filter :login_required

  def callback
    auth = request.env["omniauth.auth"]
    user = environment.users.find_by_email(auth.info.email)
    user ? login(user) : signup(auth)
  end

  def failure
    session[:notice] = _('Failed to login')
    redirect_to root_url
  end

  def destroy
    session[:user] = nil
    redirect_to root_url
  end

  def finish
    if session.delete(:oauth_client_popup) || params[:oauth_client_popup]
      current_user.private_token_expired? if current_user.present?
      private_token = current_user.present? ? current_user.private_token : ''
      render 'oauth_client_plugin_public/finish', :locals => {:private_token => private_token}, :layout => false
    else
      redirect_to :controller => :home
    end
  end

  protected

  def login(user)
    provider = OauthClientPlugin::Provider.find(session[:provider_id])
    user_provider = user.oauth_user_providers.find_by_provider_id(provider.id)
    unless user_provider
      user_provider = user.oauth_user_providers.create(:user => user, :provider => provider, :enabled => true)
    end
    # FIXME find a better way to disable providers
    if user_provider.enabled?# && provider.enabled?
      session[:user] = user.id
    else
      session[:notice] = _("Can't login with #{provider.name}")
    end
    session[:oauth_client_popup] = true if request.env.fetch("omniauth.params", {})['oauth_client_popup']
    session[:return_to] = url_for(
                            :controller => :oauth_client_plugin_public,
                            :action => :finish,
                            :user =>  {
                                        :login => current_user.login,
                                        :person => {:identifier => current_user.person.identifier, :name => current_user.person.name}
                                      } ,
                            :profile_data => {:name => current_user.person.name},
                            :oauth_client_popup => session[:oauth_client_popup]
                            )

    redirect_to :controller => :account, :action => :login
  end

  def signup(auth)
    login = auth.info.email.split('@').first

    # reading provider from session and writing to cache to read when
    # api calls register to confirm signup
    auth_cach_hash = auth.to_hash
    auth_cach_hash[:provider_id] = session[:provider_id]
    signup_token = OauthClientPlugin::SignupDataStore.store_oauth_data(auth.info.email, auth_cach_hash)

    session[:oauth_data] = auth
    session[:oauth_client_popup] = true if request.env.fetch("omniauth.params", {})['oauth_client_popup']
    session[:return_to] = url_for(:controller => :oauth_client_plugin_public, :action => :finish)
    name = auth.info.name
    name ||= auth.extra && auth.extra.raw_info ? auth.extra.raw_info.name : ''

    if session[:oauth_client_popup]
      redirect_to :controller => :oauth_client_plugin_public,
                  :action => :finish,
                  :user => {
                    :signup_token => signup_token,
                    :login => login,
                    :email => auth.info.email,
                    :oauth_providers => [session[:provider_id]]
                  },
                  :profile_data => {:name => name},
                  :oauth_client_popup => session[:oauth_client_popup]
    else
      redirect_to :controller => :account, :action => :signup, :user => {:login => login, :email => auth.info.email}, :profile_data => {:name => name}
    end
  end

end
