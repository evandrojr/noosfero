require_dependency 'community'
require 'gitlab'
#require 'jenkins_api_client'

class Community

  settings_items :allow_sonar_integration, :type => :boolean, :default => true
  settings_items :allow_gitlab_integration, :type => :boolean, :default => true
  settings_items :allow_jenkins_integration, :type => :boolean, :default => true

  #FIXME make test for default option
  settings_items :serpro_integration_plugin, :type => Hash, :default => {}

  attr_accessible :allow_unauthenticated_comments, :allow_gitlab_integration, :gitlab, :allow_sonar_integration, :sonar, :allow_jenkins_integration, :jenkins

  ##########################################
  #             Gitlab stuff               #
  ##########################################

  #after_create :create_gitlab_project

  def gitlab= params
    self.serpro_integration_plugin[:gitlab] = params
  end

  def gitlab
    self.serpro_integration_plugin[:gitlab] ||= {}
  end

  def serpro_integration_plugin_settings
    @settings ||= Noosfero::Plugin::Settings.new(environment, SerproIntegrationPlugin)
  end

  def create_gitlab_project
    Gitlab.endpoint = gitlab_host
    Gitlab.private_token = serpro_integration_plugin_settings.gitlab[:private_token]

    #Find user by email
    begin
      gitlab_user = Gitlab.users(:search => gitlab[:email])
    rescue Gitlab::Error::NotFound, Gitlab::Error::Parsing
      gitlab_user = nil
    end

    #User not found, create user
    if gitlab_user == nil || gitlab_user.count == 0
      gitlab_user = Gitlab.create_user(user.email, '123456', {:username => user.identifier, :name => user.name, :provider => 'ldap'})
    end

    if gitlab_user.nil?
      self.gitlab[:errors] = _('Gitlab user could not be created')
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
      project = Gitlab.create_project(gitlab_project_name, project_options)

      #Create Web Hook for Jenkins' integration
#      Gitlab.add_project_hook(project.id, "#{self.jenkins[:url]}/gitlab/build_now")
#      createJenkinsJob(project.name, project.path_with_namespace, project.web_url, project.http_url_to_repo)

      rescue Gitlab::Error::NotFound, Gitlab::Error::Parsing
        #Project already exists
      end

    self.gitlab[:errors] = nil
  end

  def gitlab_project_name
    gitlab[:project_name] || self.identifier
  end

  # set an API endpoint
  def gitlab_host
    serpro_integration_plugin_settings.gitlab[:host]
  end

  # set a user private token
  def gitlab_private_token
    serpro_integration_plugin_settings.gitlab[:private_token]
  end

  ##########################################
  #             Sonar stuff                #
  ##########################################

#  after_create :create_sonar_project

  def sonar= params
    self.serpro_integration_plugin[:sonar] = params
  end

  def sonar
    self.serpro_integration_plugin[:sonar] ||= {}
    self.serpro_integration_plugin[:sonar]
  end

  ##########################################
  #            Jenkins stuff               #
  ##########################################

#  after_create :create_jenkis_project

  def jenkins= params
    self.serpro_integration_plugin[:jenkins] = params
  end

  def jenkins
    self.serpro_integration_plugin[:jenkins] ||= {}
    url = "#{self.serpro_integration_plugin[:jenkins][:host]}:"
    url += "#{self.serpro_integration_plugin[:jenkins][:port]}/"
    url += "#{self.serpro_integration_plugin[:jenkins][:context_name]}"   
    self.serpro_integration_plugin[:jenkins][:url] = url
    self.serpro_integration_plugin[:jenkins]
  end


  #FIXME make jenkins integration works
  def create_jenkis_project
#(projectName, repositoryPath, webUrl, gitUrl)

    @client = JenkinsApi::Client.new(:server_url => "#{$jenkins_url}/",
                                     :password => $jenkins_private_token,
                                     :username => $jenkins_user)

    xmlJenkins = ""

#    xmlJenkins = "
#        <maven2-moduleset plugin='maven-plugin@1.509'>
#            <actions/>
#            <description>Projeto criado para o repositório #{repositoryPath} do Gitlab - #{webUrl}</description>
#            <logRotator class='hudson.tasks.LogRotator'>
#                <daysToKeep>-1</daysToKeep>
#                <numToKeep>2</numToKeep>
#                <artifactDaysToKeep>-1</artifactDaysToKeep>
#                <artifactNumToKeep>-1</artifactNumToKeep>
#            </logRotator>
#            <keepDependencies>false</keepDependencies>
#            <properties/>
#            <scm class='hudson.plugins.git.GitSCM' plugin='git@2.2.1'>
#                <configVersion>2</configVersion>
#                <userRemoteConfigs>
#                    <hudson.plugins.git.UserRemoteConfig>
#                        <url>#{gitUrl}</url>
#                    </hudson.plugins.git.UserRemoteConfig>
#                </userRemoteConfigs>
#                <branches>
#                    <hudson.plugins.git.BranchSpec>
#                    <name>*/master</name>
#                    </hudson.plugins.git.BranchSpec>
#                </branches>
#                <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
#                <submoduleCfg class='list'/>
#                <extensions/>
#            </scm>
#            <canRoam>true</canRoam>
#            <disabled>false</disabled>
#            <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
#            <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
#            <jdk>(Inherit From Job)</jdk>
#            <triggers class='vector'/>
#            <concurrentBuild>false</concurrentBuild>
#            <goals>clean package install deploy</goals>
#            <aggregatorStyleBuild>true</aggregatorStyleBuild>
#            <incrementalBuild>false</incrementalBuild>
#            <perModuleEmail>true</perModuleEmail>
#            <ignoreUpstremChanges>false</ignoreUpstremChanges>
#            <archivingDisabled>false</archivingDisabled>
#            <resolveDependencies>false</resolveDependencies>
#            <processPlugins>false</processPlugins>
#            <mavenValidationLevel>-1</mavenValidationLevel>
#            <runHeadless>false</runHeadless>
#            <disableTriggerDownstreamProjects>false</disableTriggerDownstreamProjects>
#            <settings class='jenkins.mvn.DefaultSettingsProvider'/>
#            <globalSettings class='jenkins.mvn.DefaultGlobalSettingsProvider'/>
#            <reporters>
#                <hudson.maven.reporters.MavenMailer>
#                    <recipients/>
#                    <dontNotifyEveryUnstableBuild>false</dontNotifyEveryUnstableBuild>
#                    <sendToIndividuals>true</sendToIndividuals>
#                    <perModuleEmail>true</perModuleEmail>
#                </hudson.maven.reporters.MavenMailer>
#            </reporters>
#            <publishers>
#                <hudson.plugins.sonar.SonarPublisher plugin='sonar@2.1'>
#                    <jdk>(Inherit From Job)</jdk>
#                    <branch/>
#                    <language/>
#                    <mavenOpts/>
#                    <jobAdditionalProperties/>
#                    <settings class='jenkins.mvn.DefaultSettingsProvider'/>
#                    <globalSettings class='jenkins.mvn.DefaultGlobalSettingsProvider'/>
#                    <usePrivateRepository>false</usePrivateRepository>
#                </hudson.plugins.sonar.SonarPublisher>
#            </publishers>
#            <buildWrappers/>
#            <prebuilders/>
#            <postbuilders/>
#            <runPostStepsIfResult>
#                <name>FAILURE</name>
#                <ordinal>2</ordinal>
#                <color>RED</color>
#            </runPostStepsIfResult>
#        </maven2-moduleset>
#    "

    begin
        @client.job.create(projectName, xmlJenkins)
    rescue JenkinsApi::Exceptions::ApiException 
        
    end

  end


end
