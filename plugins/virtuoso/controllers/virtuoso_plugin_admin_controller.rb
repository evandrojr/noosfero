class VirtuosoPluginAdminController < AdminController

  def index
    settings = params[:settings] 
    settings ||= {}
    
#    raise settings.inspect.to_yaml
    
#    --- ! '{"virtuoso_uri"=>"http://hom.virtuoso.participa.br", "virtuoso_username"=>"dba",
#  "virtuoso_password"=>"dasas", "dspace_uri"=>"http://hom.dspace.participa.br"}#'
    
    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, settings)
    @harvest_running = VirtuosoPlugin::DspaceHarvest.new(environment).find_job.present?

    if request.post?
      @settings.save!
      session[:notice] = 'Settings successfully saved.'
      redirect_to :action => 'index'
    end
  end

  def force_harvest
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment)
    harvest.start(params[:from_start])
    session[:notice] = _('Harvest started')
    redirect_to :action => :index
  end

  def triple_management
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

    triples.each { |triple|
      from_triple = triple[:from]
      to_triple = triple[:to]
      triples_management.update_triple(graph_uri, from_triple, to_triple)
    }

    session[:notice] = _('Triple(s) succesfully updated.')
    redirect_to :action => :triple_management
  end

end
