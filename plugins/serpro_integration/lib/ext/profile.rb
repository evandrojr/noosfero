require_dependency 'profile'

class Profile
  settings_items :allow_sonar_integration, :type => :boolean, :default => true
  settings_items :allow_gitlab_integration, :type => :boolean, :default => true

  #FIXME make test for default option
  settings_items :serpro_integration_plugin, :type => Hash, :default => {}
end
