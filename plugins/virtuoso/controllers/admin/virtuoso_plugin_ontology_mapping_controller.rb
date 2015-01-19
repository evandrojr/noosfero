class VirtuosoPluginOntologyMappingController < PluginAdminController

  def index
    @settings = VirtuosoPlugin.new(self).settings
    if request.post?
      @settings.ontology_mapping = params['ontology_mapping']
      @settings.save!
      session[:notice] = _('Saved!')
    end
    @ontology_mapping = @settings.ontology_mapping
  end

end
