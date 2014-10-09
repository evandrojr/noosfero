class OauthClientPluginAdminController < AdminController

  def index
    settings = params[:settings] || {}

    @settings = Noosfero::Plugin::Settings.new(environment, OauthClientPlugin, settings)
    @providers = @settings.get_setting(:providers) || {}
    if request.post?
      @settings.save!
      session[:notice] = 'Settings succefully saved.'
      redirect_to :action => 'index'
    end
  end

end
