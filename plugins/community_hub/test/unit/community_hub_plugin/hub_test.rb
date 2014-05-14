require File.dirname(__FILE__) + '/../../test_helper'

class HubTest < ActiveSupport::TestCase

  def setup
    @env = fast_create(Environment)
    @user = create_user('testuser', :environment => @env).person
    @comm = fast_create(Community, :environment_id => @env.id)
    @hub = create_hub('hub', @comm, @user)
  end

  should 'has setting twitter_enable' do
    assert_respond_to @hub, :twitter_enabled
  end

  should 'default value of setting twitter_enabled is false' do
    assert_equal @hub.twitter_enabled, false
  end

  should 'has setting twitter_hashtags' do
    assert_respond_to @hub, :twitter_hashtags
  end

  should 'default value of setting twitter_hashtags is blank' do
    assert_equal @hub.twitter_hashtags, ""
  end

  should 'has setting twitter_consumer_key' do
    assert_respond_to @hub, :twitter_consumer_key
  end

  should 'default value of setting twitter_consumer is blank' do
    assert_equal @hub.twitter_consumer_key, ""
  end

  should 'has setting twitter_consumer_secret' do
    assert_respond_to @hub, :twitter_consumer_secret
  end

  should 'default value of setting twitter_consumer_secret is blank' do
    assert_equal @hub.twitter_consumer_secret, ""
  end

  should 'has setting twitter_access_token' do
    assert_respond_to @hub, :twitter_access_token
  end

  should 'default value of setting twitter_access_token is blank' do
    assert_equal @hub.twitter_access_token, ""
  end

  should 'has setting twitter_access_token_secret' do
    assert_respond_to @hub, :twitter_access_token_secret
  end

  should 'default value of setting twitter_access_token_secret' do
    assert_equal @hub.twitter_access_token_secret, ""
  end

  should 'has setting facebook_enabled' do
    assert_respond_to @hub, :facebook_enabled
  end

  should 'default value of setting facebook_enabled is false' do
    assert_equal @hub.facebook_enabled, false
  end

  should 'has setting facebook_page_id' do
    assert_respond_to @hub, :facebook_page_id
  end

  should 'default value of setting facebook_page_id' do
    assert_equal @hub.facebook_page_id, ""
  end

  should 'has setting facebook_pooling_time' do
    assert_respond_to @hub, :facebook_pooling_time
  end

  should 'default value of setting facebook_pooling_time id five (5)' do
    assert_equal @hub.facebook_pooling_time, 5
  end

  should 'has setting facebook_access_token' do
    assert_respond_to @hub, :facebook_access_token
  end

  should 'default value of setting facebook_access_token is blank' do
    assert_equal @hub.facebook_access_token, ""
  end

  should 'has pinned_messages' do
    assert_respond_to @hub, :pinned_messages
  end

  should 'default value of pinned_messags' do
    assert_equal @hub.pinned_messages, []
  end

  should 'has pinned_mediations' do
    assert_respond_to @hub, :pinned_mediations
  end

  should 'default value of pinned_mediations' do
    assert_equal @hub.pinned_mediations, []
  end

  should 'has mediators' do
    assert_respond_to @hub, :mediators
  end

  should 'hub creator is mediator by default' do
    assert @hub.mediators.include?(@user.id)
  end

  should 'describe yourself' do
    assert CommunityHubPlugin::Hub.description
  end

  should 'has a short descriptionf' do
    assert CommunityHubPlugin::Hub.short_description
  end

  should 'accept comments by default' do
    assert @hub.accept_comments?
  end

  should 'do not notify comments by default' do
    assert !@hub.notify_comments
  end

  should 'has a view page' do
    assert @hub.view_page
  end

end
