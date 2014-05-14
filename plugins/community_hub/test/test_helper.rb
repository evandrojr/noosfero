require File.dirname(__FILE__) + '/../../../test/test_helper'

def create_hub(name, community, user)
  hub = CommunityHubPlugin::Hub.new(:abstract => 'abstract', :body => 'body', :name => name, :profile => community, :last_changed_by_id => user.id )
  hub.save!
  hub
end
