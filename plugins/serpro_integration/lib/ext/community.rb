require_dependency 'community'

class Community

  settings_items :allow_sonar_integration, :type => :boolean, :default => true
  settings_items :allow_gitlab_integration, :type => :boolean, :default => true
  settings_items :allow_jenkins_integration, :type => :boolean, :default => true

  #FIXME make test for default option
  settings_items :serpro_integration_plugin, :type => Hash, :default => {}

  attr_accessible :allow_unauthenticated_comments, :allow_gitlab_integration, :gitlab, :allow_sonar_integration, :sonar, :allow_jenkins_integration, :jenkins

  after_update :create_integration_projects

  def create_integration_projects
    gitlab_project = SerproIntegrationPlugin::GitlabIntegration.create_gitlab_project(self)
    SerproIntegrationPlugin::JenkinsIntegration.create_jenkis_project(self, jenkins_project_name, gitlab_project.path_with_namespace, gitlab_project.web_url, gitlab_project.http_url_to_repo)
  end

  def serpro_integration_plugin_settings
    @settings ||= Noosfero::Plugin::Settings.new(environment, SerproIntegrationPlugin)
  end

  def gitlab= params
    self.serpro_integration_plugin[:gitlab] = params
  end

  def gitlab
    self.serpro_integration_plugin[:gitlab] ||= {}
  end

  def gitlab_project_name
    gitlab[:project_name] || self.identifier
  end

  def gitlab_host
    serpro_integration_plugin_settings.gitlab[:host]
  end

  def gitlab_private_token
    serpro_integration_plugin_settings.gitlab[:private_token]
  end

  def sonar= params
    self.serpro_integration_plugin[:sonar] = params
  end

  def sonar
    self.serpro_integration_plugin[:sonar] ||= {}
  end

  def jenkins= params
    self.serpro_integration_plugin[:jenkins] = params
  end

  def jenkins
    self.serpro_integration_plugin[:jenkins] ||= {}
  end

  def jenkins_project_name
    jenkins[:project_name] || self.identifier
  end

end
