class VirtuosoPluginAdminController < AdminController

  def index
    settings = params[:settings]
    settings ||= {}
    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, settings)
    @harvest_running = {}
    if @settings.dspace_servers.present?
      @settings.dspace_servers.each do |i|
        @harvest_running[i['dspace_uri']] = VirtuosoPlugin::DspaceHarvest.new(environment, i).find_job(i['dspace_uri']).present?
      end
    end
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

  def update_triple
    if request.post?
      from_triple = VirtuosoPlugin::Triple.new
      from_triple.graph = params[:from_triple][:graph]
      from_triple.subject = params[:from_triple][:subject]
      from_triple.predicate = params[:from_triple][:predicate]
      from_triple.object = params[:from_triple][:object]

      to_triple = VirtuosoPlugin::Triple.new
      to_triple.graph = params[:to_triple][:graph]
      to_triple.subject = params[:to_triple][:subject]
      to_triple.predicate = params[:to_triple][:predicate]
      to_triple.object = params[:to_triple][:object]

      triples_management = VirtuosoPlugin::TriplesManagement.new(environment)

      triple_updated = triples_management.update_triple(from_triple, to_triple)
      message = triple_updated ? _('Triple succesfully updated.') : _('Triple not updated.')

      render json: { :ok => triple_updated, :message => message }
    end
  end

  def add_triple
    if request.post?
      triple = VirtuosoPlugin::Triple.new
      triple.graph = params[:triple][:graph]
      triple.subject = params[:triple][:subject]
      triple.predicate = params[:triple][:predicate]
      triple.object = params[:triple][:object]

      triples_management = VirtuosoPlugin::TriplesManagement.new(environment)

      triple_added = triples_management.add_triple(triple)
      message = triple_added ? _('Triple succesfully added.') : _('Triple not added.')

      render json: { :ok => triple_added, :message => message }
    end
  end

  def remove_triple
    if request.post?
      triple = VirtuosoPlugin::Triple.new
      triple.graph = params[:triple][:graph]
      triple.subject = params[:triple][:subject]
      triple.predicate = params[:triple][:predicate]
      triple.object = params[:triple][:object]

      triples_management = VirtuosoPlugin::TriplesManagement.new(environment)

      triple_deleted = triples_management.remove_triple(triple)
      message = triple_deleted ? _('Triple succesfully removed.') : _('Triple not removed.')

      render json: { :ok => triple_deleted, :message => message }
    end
  end

end
