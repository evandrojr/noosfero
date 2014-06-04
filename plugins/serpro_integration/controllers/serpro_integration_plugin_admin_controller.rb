class SerproIntegrationPluginAdminController < AdminController

  def index
    settings = params[:settings]
    settings ||= {}

    @settings = Noosfero::Plugin::Settings.new(environment, SerproIntegrationPlugin, settings)
    if request.post?
      @settings.save!
      session[:notice] = 'Settings succefully saved.'
      redirect_to :action => 'index'
    end
  end

end
