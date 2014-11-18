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
    @virtuoso_client ||= virtuoso_client_builder(settings.virtuoso_uri, settings.virtuoso_username, settings.virtuoso_password)
  end

  def virtuoso_readonly_client
    @virtuoso_readonly_client ||= virtuoso_client_builder(settings.virtuoso_uri, settings.virtuoso_readonly_username, settings.virtuoso_readonly_password)
  end

  def stylesheet?
    true
  end

  protected

  def virtuoso_client_builder(uri, username, password)
    RDF::Virtuoso::Repository.new("#{uri}/sparql", :update_uri => "#{uri}/sparql-auth", :username => username, :password => password, :auth_method => 'digest', :timeout => 30)
  end

end
