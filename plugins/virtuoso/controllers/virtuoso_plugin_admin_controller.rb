class VirtuosoPluginAdminController < AdminController

  def index
    settings = params[:settings]
    settings ||= {}
    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, settings)
    @harvest_running = VirtuosoPlugin::DspaceHarvest.new(environment).find_job.present?
    if request.post?
      settings[:dspace_servers].delete_if do | server |
        server[:dspace_uri].empty?
      end
      @settings.save!
      session[:notice] = 'Settings successfully saved.'
      redirect_to :action => 'index'
    end
  end

  def force_harvest
    VirtuosoPlugin::DspaceHarvest.harvest_all(environment, params[:from_start])
    session[:notice] = _('Harvest started')
    redirect_to :action => :index
  end

  def triples_management
    triples_management = VirtuosoPlugin::TriplesManagement.new(environment)
    @triples = []
    if request.post?
      @query = params[:query]
      @graph_uri = params[:graph_uri]
      @triples = triples_management.search_triples(@graph_uri, @query)
    end
    render :action => 'triple_management'
  end

  def triple_update
    graph_uri = params[:graph_uri]
    triples = params[:triples]

    triples_management = VirtuosoPlugin::TriplesManagement.new(environment)

    triples.each { |triple_key, triple_content|
      triples_management.update_triple(graph_uri, triple_content[:from], triple_content[:to])
    }

    session[:notice] = _('Triple(s) succesfully updated.')
    redirect_to :action => :triple_management
  end

  def add_triple
    if request.post?

      triple = VirtuosoPlugin::Triple.new
      triple.graph = params[:triple][:graph]
      triple.subject = params[:triple][:subject]
      triple.predicate = params[:triple][:predicate]
      triple.object = params[:triple][:object]

      triples_management = VirtuosoPlugin::TriplesManagement.new(environment)
      triples_management.add_triple(triple)

      @triples = []

      session[:notice] = _('Triple succesfully added.')
      render :action => :triple_management
    end
  end

  def remove_triple
    triple = VirtuosoPlugin::Triple.new
    triple.graph = params[:triple][:graph]
    triple.subject = params[:triple][:subject]
    triple.predicate = params[:triple][:predicate]
    triple.object = params[:triple][:object]

    triples_management = VirtuosoPlugin::TriplesManagement.new(environment)
    triples_management.remove_triple(triple)

    render json: { :ok => true, :message => _('Triple succesfully removed.') }
  end

end
