class OauthClientPluginPublicController < PublicController

  def callback
    auth = request.env["omniauth.auth"]
    login = auth.info.email.split('@').first
    user = environment.users.find_with_omniauth(auth)

    if user
      session[:user] = user
      redirect_to :controller => :account, :action => :login
    else
      session[:oauth_data] = auth
      name = auth.info.name
      name ||= auth.extra && auth.extra.raw_info ? auth.extra.raw_info.name : ''
      redirect_to :controller => :account, :action => :signup, :user => {:login => login, :email => auth.info.email}, :profile_data => {:name => name}
    end
  end

  def failure
    session[:notice] = _('Failed to login')
    redirect_to root_url
  end

  def destroy
    session[:user] = nil
    redirect_to root_url
  end

end
