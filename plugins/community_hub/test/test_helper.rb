require File.dirname(__FILE__) + '/../../../test/test_helper'

def create_hub(name, community, user)
  hub = CommunityHubPlugin::Hub.new(:abstract => 'abstract', :body => 'body', :name => name, :profile => community, :last_changed_by_id => user.id )
  hub.save!
  hub
end

def create_mediation(hub, community)
  mediation = CommunityHubPlugin::Mediation.new(:profile => community)
  mediation.name = CommunityHubPlugin::Mediation.timestamp
  mediation.save!
  mediation
end
