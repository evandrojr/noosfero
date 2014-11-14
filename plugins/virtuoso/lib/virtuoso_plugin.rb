class VirtuosoPlugin < Noosfero::Plugin

  @virtuosoServers
  
  def self.plugin_name
    "Virtuoso integration"
  end

  def self.plugin_description
    _('Virtuoso integration')
  end

  def content_types
    [VirtuosoPlugin::TriplesTemplate]
  end

  def settings
    @settings ||= Noosfero::Plugin::Settings.new(context.environment, VirtuosoPlugin)
  end

  def virtuoso_client
    @virtuoso_client ||= RDF::Virtuoso::Repository.new("#{settings.virtuoso_uri}/sparql", :update_uri => "#{settings.virtuoso_uri}/sparql-auth", :username => settings.virtuoso_username, :password => settings.virtuoso_password, :auth_method => 'digest', :timeout => 30)
  end
  
  def js_files
    ['edit-server-list']
  end  

  def stylesheet?
    true
  end

end
