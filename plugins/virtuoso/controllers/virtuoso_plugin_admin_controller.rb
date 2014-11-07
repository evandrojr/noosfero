class VirtuosoPluginAdminController < AdminController

  def index
    settings = params[:settings]
    settings ||= {}
    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, settings)
    @harvest_running = VirtuosoPlugin::DspaceHarvest.new(environment).find_job.present?

    if request.post?
      @settings.save!
      session[:notice] = 'Settings succefully saved.'
      redirect_to :action => 'index'
    end
  end

  def force_harvest
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment)
    harvest.start(params[:from_start])
    session[:notice] = _('Harvest started')
    redirect_to :action => :index
  end

end
