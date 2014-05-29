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

def create_message(hub,user)
  message = Comment.new
  message.author = user
  message.title = "hub-message-#{(Time.now.to_f * 1000).to_i}"
  message.body = 'body'
  message.article = hub
  message.save!
  message
end

def create_mediation(hub, user, community)

  #raise community.inspect
  mediation = CommunityHubPlugin::Mediation.new
  mediation.name = CommunityHubPlugin::Mediation.timestamp
  mediation.profile = community
  mediation.last_changed_by = user
  mediation.created_by_id = user.id
  mediation.source = 'local'
  mediation.parent_id = hub.id
  mediation.save!
  mediation
end
