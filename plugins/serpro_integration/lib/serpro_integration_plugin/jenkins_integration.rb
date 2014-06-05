# encoding: UTF-8
require 'jenkins_api_client'

class SerproIntegrationPlugin::JenkinsIntegration
  #FIXME make jenkins integration works
  def self.create_jenkis_project(profile, projectName, repositoryPath, webUrl, gitUrl)

    @client = JenkinsApi::Client.new(:server_url => profile.serpro_integration_plugin_settings.jenkins[:host],
                                     :password => profile.serpro_integration_plugin_settings.jenkins[:private_token],
                                     :username => profile.serpro_integration_plugin_settings.jenkins[:user])

    #begin
        @client.job.create(projectName, xml_jenkins(repositoryPath, webUrl, gitUrl))
    #rescue JenkinsApi::Exceptions::ApiException

    #end

  end

  #FIXME
  def self.xml_jenkins(repositoryPath, webUrl, gitUrl)
    "
        <maven2-moduleset plugin='maven-plugin@1.509'>
            <actions/>
            <description>Projeto criado para o repositório #{repositoryPath} do Gitlab - #{webUrl}</description>
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
                        <url>#{gitUrl}</url>
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
