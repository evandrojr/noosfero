require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../controllers/public/community_hub_plugin_public_controller'

class CommunityHubPluginPublicController; def rescue_action(e) raise e end; end

class CommunityHubPluginPublicControllerTest < ActionController::TestCase

  all_fixtures

  def setup
    @controller = CommunityHubPluginPublicController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @user = create_user('testinguser').person

    @environment = @user.environment

    @community = Community.create!(
      :name => 'Sample community',
      :identifier => 'sample-community',
      :environment => @environment
    )

    @community.save!

    @hub = CommunityHubPlugin::Hub.new(
      :abstract => 'abstract',
      :body => 'body',
      :name => 'test-hub',
      :profile => community,
      :last_changed_by_id => user.id
    )

    @hub.save!

  end

  attr_reader :user, :environment, :community, :hub

  should 'display pin message flag if user is logged and hub\'s mediator' do
    message = create_message( hub, user )
    login_as(user.user.login)
    xhr :get, :newer_comments, { :latest_post => 0, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :class => 'pin' }
  end

  should 'not display pin message flag if user is not hub'' mediator' do
    message = create_message( hub, user )
    visitor = create_user('visitor')
    login_as(visitor.login)
    xhr :get, :newer_comments, { :latest_post => 0, :hub => hub.id }
    assert_no_tag :tag => 'li', :attributes => { :class => 'pin' }
  end

  should 'pin message flag is link if message has not been pinned' do
    message = create_message( hub, user )
    login_as(user.user.login)
    xhr :get, :newer_comments, { :latest_post => 0, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :class => 'pin' }, :descendant => {
                 :tag => 'a', :descendant => {
                   :tag => 'img', :attributes => { :class => 'not-pinned' }
                 }
               }
  end

  should 'ping message flag is not link if message has beem pinned' do
    message = create_message( hub, user )
    hub.pinned_messages += [message.id]
    hub.save
    login_as(user.user.login)
    xhr :get, :newer_comments, { :latest_post => 0, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :class => 'pin' }, :descendant => {
                 :tag => 'img', :attributes => { :class => 'pinned' }
               }
  end

  should 'display promote user flag if user is logged and hub\s mediator' do
    mediation = create_mediation(hub, user, community)
    login_as(user.user.login)
    xhr :get, :newer_articles, { :latest_post => 0, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :class => 'promote' }
  end

  should 'not display promote user flag if user is not hub''s mediator' do
    mediation = create_mediation(hub, user, community)
    visitor = create_user('visitor')
    login_as(visitor.login)
    xhr :get, :newer_articles, { :latest_post => 0, :hub => hub.id }
    assert_no_tag :tag => 'li', :attributes => { :class => 'promote' }
  end

  should 'promote user flag is link if user has not been promoted' do
    visitor = create_user('visitor').person
    mediation = create_mediation(hub, visitor, community)
    login_as(user.user.login)
    xhr :get, :newer_articles, { :latest_post => 0, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :class => 'promote' }, :descendant => {
                 :tag => 'a', :descendant => {
                   :tag => 'img', :attributes => { :class => 'not-promoted' }
                 }
               }
  end

  should 'promote user flag is not link if user has been promoted' do
    mediation = create_mediation(hub, user, community)
    login_as(user.user.login)
    xhr :get, :newer_articles, { :latest_post => 0, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :class => 'promote' }, :descendant => {
                 :tag => 'img', :attributes => { :class => 'promoted' }
               }
  end

  should 'promote user flag is not link if user is hub''s owner' do
    mediation = create_mediation(hub, user, community)
    login_as(user.user.login)
    xhr :get, :newer_articles, { :latest_post => 0, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :class => 'promote' }, :descendant => {
                 :tag => 'img', :attributes => { :class => 'promoted' }
               }
  end

end

