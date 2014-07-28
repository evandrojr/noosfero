# encoding: UTF-8
require 'jenkins_api_client'

class SerproIntegrationPlugin::JenkinsIntegration

  def initialize(host, private_token, user)
    @client = JenkinsApi::Client.new(:server_url => host, :password => private_token, :username => user)
    @profile = nil

  end

  def project_url
    "#{jenkins_host}/#{jenkins_project_name}"
  end

  #FIXME make jenkins integration works
  def create_jenkis_project(profile, repository_path, web_url, git_url)
    @profile = profile
    #begin
    project_name = repository_path.split('/').last
    if @client.job.list(project_name).blank?
      @client.job.create(profile.jenkins_project_name, xml_jenkins(repository_path, web_url, git_url))
    end
    #rescue JenkinsApi::Exceptions::ApiException
    #end
  end

  #FIXME
  def xml_jenkins(repository_path, web_url, git_url)
    "
        <maven2-moduleset plugin='maven-plugin@1.509'>
            <actions/>
            <description>Projeto criado para o repositório #{repository_path} do Gitlab - #{web_url}</description>
            <logRotator class='hudson.tasks.LogRotator'>
                <daysToKeep>-1</daysToKeep>
                <numToKeep>2</numToKeep>
                <artifactDaysToKeep>-1</artifactDaysToKeep>
                <artifactNumToKeep>-1</artifactNumToKeep>
            </logRotator>
            <keepDependencies>false</keepDependencies>
            <properties/>
            <scm class='hudson.plugins.git.GitSCM' plugin='git@2.2.1'>
                <configVersion>2</configVersion>
                <userRemoteConfigs>
                    <hudson.plugins.git.UserRemoteConfig>
                        <url>#{git_url}</url>
                    </hudson.plugins.git.UserRemoteConfig>
                </userRemoteConfigs>
                <branches>
                    <hudson.plugins.git.BranchSpec>
                    <name>*/master</name>
                    </hudson.plugins.git.BranchSpec>
                </branches>
                <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
                <submoduleCfg class='list'/>
                <extensions/>
            </scm>
            <canRoam>true</canRoam>
            <disabled>false</disabled>
            <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
            <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
            <jdk>(Inherit From Job)</jdk>
            <triggers class='vector'/>
            <concurrentBuild>false</concurrentBuild>
            <goals>clean package install deploy</goals>
            <aggregatorStyleBuild>true</aggregatorStyleBuild>
            <incrementalBuild>false</incrementalBuild>
            <perModuleEmail>true</perModuleEmail>
            <ignoreUpstremChanges>false</ignoreUpstremChanges>
            <archivingDisabled>false</archivingDisabled>
            <resolveDependencies>false</resolveDependencies>
            <processPlugins>false</processPlugins>
            <mavenValidationLevel>-1</mavenValidationLevel>
            <runHeadless>false</runHeadless>
            <disableTriggerDownstreamProjects>false</disableTriggerDownstreamProjects>
            <settings class='jenkins.mvn.DefaultSettingsProvider'/>
            <globalSettings class='jenkins.mvn.DefaultGlobalSettingsProvider'/>
            <reporters>
                <hudson.maven.reporters.MavenMailer>
                    <recipients/>
                    <dontNotifyEveryUnstableBuild>false</dontNotifyEveryUnstableBuild>
                    <sendToIndividuals>true</sendToIndividuals>
                    <perModuleEmail>true</perModuleEmail>
                </hudson.maven.reporters.MavenMailer>
            </reporters>
            <publishers>
                <hudson.plugins.sonar.SonarPublisher plugin='sonar@2.1'>
                    <jdk>(Inherit From Job)</jdk>
                    <branch/>
                    <language/>
                    <mavenOpts/>
                    <jobAdditionalProperties/>
                    <settings class='jenkins.mvn.DefaultSettingsProvider'/>
                    <globalSettings class='jenkins.mvn.DefaultGlobalSettingsProvider'/>
                    <usePrivateRepository>false</usePrivateRepository>
                </hudson.plugins.sonar.SonarPublisher>
            </publishers>
            <buildWrappers/>
            <prebuilders/>
            <postbuilders/>
            <runPostStepsIfResult>
                <name>FAILURE</name>
                <ordinal>2</ordinal>
                <color>RED</color>
            </runPostStepsIfResult>
        </maven2-moduleset>
    "
  end
end
