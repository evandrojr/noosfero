require 'gitlab'

class SerproIntegrationPlugin::GitlabIntegration

  def self.create_gitlab_project(profile)
    Gitlab.endpoint = profile.gitlab_host
    Gitlab.private_token = profile.serpro_integration_plugin_settings.gitlab[:private_token]

    #Find user by email
    begin
      gitlab_user = Gitlab.users(:search => profile.gitlab[:email])
    rescue Gitlab::Error::NotFound, Gitlab::Error::Parsing
      gitlab_user = nil
    end

    #User not found, create user
    #FIXME
    if gitlab_user == nil || gitlab_user.count == 0
      gitlab_user = Gitlab.create_user(user.email, '123456', {:username => user.identifier, :name => user.name, :provider => 'ldap'})
    end

    if gitlab_user.nil?
      profile.gitlab[:errors] = _('Gitlab user could not be created')
      return nil
    end

    #Create project for user
    begin
      #FIXME Why this?
      if gitlab_user.is_a?(Array)
        gitlab_user = gitlab_user[0]
      end

      project_options = {}
      project_options[:user_id] = gitlab_user.id
      project_options[:issues_enabled ] = true
      project_options[:wall_enabled] = true
      project_options[:wiki_enabled] = true
      project_options[:public] = true
      project = Gitlab.create_project(profile.gitlab_project_name, project_options)

      #Create Web Hook for Jenkins' integration
#      Gitlab.add_project_hook(project.id, "#{self.jenkins[:url]}/gitlab/build_now")
#      createJenkinsJob(project.name, project.path_with_namespace, project.web_url, project.http_url_to_repo)

      rescue Gitlab::Error::NotFound, Gitlab::Error::Parsing
        #Project already exists
      end
    profile.gitlab[:errors] = nil
    project
  end


end
