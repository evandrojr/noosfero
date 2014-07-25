require 'gitlab'

class SerproIntegrationPlugin::GitlabIntegration

  def initialize(host, private_token)
    @client = Gitlab.client(:endpoint => host, :private_token => private_token)
    @group = nil
    @project = nil
  end

  def create_group(group_name)
    #FIXME find group by name
    group = @client.groups.select {|group| group.name == group_name}.first
    group ||= @client.create_group(group_name, group_name)
    @group = group
  end

  def create_project(project_name, group)
    path_with_namespace = "#{group.name}/#{project_name}"
    #FIXME find project by namespace
    project = @client.get("/projects/search/#{project_name}").select do |project|
      project.path_with_namespace == path_with_namespace
    end.first

    if project.nil?
      project_options = {}
      project_options[:namespace_id] = group.id
      project_options[:issues_enabled ] = true
      project_options[:wall_enabled] = true
      project_options[:wiki_enabled] = true
      project_options[:public] = true

      project = @client.create_project(project_name, project_options)
      #Create Web Hook for Jenkins' integration
      #Gitlab.add_project_hook(project.id, "#{self.jenkins[:url]}/gitlab/build_now")
    end
    @project = project
  end

  def create_user(email, group)
    user = @client.users(:search => email).first
    username = name = email[/[^@]+/]
    user ||= @client.create_user(email, '123456', {:username => username, :name => name, :provider => 'ldap'})

    begin
      @client.add_group_member(group.id, user.id, 40)
    rescue Gitlab::Error::Conflict => e
      #already member
    end
    user
  end

  #http://rubydoc.info/gems/gitlab/frames
  def create_gitlab_project(profile)
    group = create_group(profile.gitlab_group)

    #create admins and add to group
    profile.admins.each do |person|
      create_user(person.user.email, group)
    end

    project = create_project(profile.gitlab_project_name, group)
  end


  def create_jenkins_hook(jenkins_project_url)
    @client.add_project_hook(@project.id, "#{jenkins_project_url}/gitlab/build_now")
  end

end
