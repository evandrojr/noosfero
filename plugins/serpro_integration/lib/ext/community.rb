require_dependency 'community'
#require 'gitlab'
#require 'jenkins_api_client'

class Community

  settings_items :allow_sonar_integration, :type => :boolean, :default => true
  settings_items :allow_gitlab_integration, :type => :boolean, :default => true
  settings_items :allow_jenkins_integration, :type => :boolean, :default => true

  #FIXME make test for default option
  settings_items :serpro_integration_plugin, :type => Hash

  ##########################################
  #             Gitlab stuff               #
  ##########################################

  after_create :create_gitlab_project

  def gitlab= params
    self.serpro_integration_plugin[:gitlab] = params
  end

  def gitlab
    self.serpro_integration_plugin ||= {}
    self.serpro_integration_plugin[:gitlab] ||= {}
    self.serpro_integration_plugin[:gitlab]
  end

  def create_gitlab_project
    Gitlab.endpoint =  self.gitlab_host
    Gitlab.private_token = self.gitlab_private_token

    user = nil

    #Find user by email
    begin
      user = Gitlab.users(:search => email)        
    rescue Gitlab::Error::NotFound, Gitlab::Error::Parsing
      user = nil
    end

    #User not found, create user
    if user == nil || user.count == 0        
      user = self.admins.first
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
        gitlab_user = user[0]
      end

      project_options = {}
      project_options[:user_id] = gitlab_user.id
      project_options[:issues_enabled ] = true
      project_options[:wall_enabled] = true
      project_options[:wiki_enabled] = true
      project_options[:public] = true
      project = Gitlab.create_project(self.identifier, project_options)

      #Create Web Hook for Jenkins' integration
#      Gitlab.add_project_hook(project.id, "#{self.jenkins[:url]}/gitlab/build_now")
#      createJenkinsJob(project.name, project.path_with_namespace, project.web_url, project.http_url_to_repo)

      rescue Gitlab::Error::NotFound, Gitlab::Error::Parsing
        #Project already exists
      end

    self.gitlab[:errors] = nil
  end

  # set an API endpoint
  def gitlab_host
    self.serpro_integration_plugin[:gitlab_host]
  end

  # set a user private token
  def gitlab_private_token
    self.serpro_integration_plugin[:gitlab_private_token]
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
