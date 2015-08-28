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

  should 'display pin message flag if user is logged and mediator' do
    message = create_message( hub, user )
    login_as(user.user.login)
    xhr :get, :newer_comments, { :latest_post => 0, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :class => 'pin' }
  end

  should 'not display pin message flag if user is not mediator' do
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

  should 'display promote user flag if user is logged and mediator' do
    mediation = create_mediation(hub, user, community)
    login_as(user.user.login)
    xhr :get, :newer_articles, { :latest_post => 0, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :class => 'promote' }
  end

  should 'not display promote user flag if user is not mediator' do
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

  should 'should create new message' do
    login_as(user.user.login)
    xhr :post, :new_message, { :article_id => hub.id, :message => {"body"=>"testmessage"} }
    response = JSON.parse(@response.body)
    assert_equal true, response['ok']
  end

  should 'should create new mediation' do
    login_as(user.user.login)
    xhr :post, :new_mediation, { :profile_id => community.id, :article => { "parent_id" => hub.id , "body" => "<p>testmediation</p>" } }
    response = JSON.parse(@response.body)
    assert_equal true, response['ok']
  end

  should 'should create new mediation comment' do
    login_as(user.user.login)
    mediation = create_mediation(hub, user, community)
    xhr :post, :new_message, { "article_id" => mediation.id, "message" => {"body"=>"testmediationcomment"} }
    response = JSON.parse(@response.body)
    assert_equal true, response['ok']
  end

  should 'should get newer messages' do
    message1 = create_message( hub, user )
    message2 = create_message( hub, user )
    message3 = create_message( hub, user )
    xhr :get, :newer_comments, { :latest_post => message2.id, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :id => message3.id }
  end

  should 'should get oldest messages' do
    message1 = create_message( hub, user )
    message2 = create_message( hub, user )
    message3 = create_message( hub, user )
    xhr :get, :older_comments, { :oldest_id => message2.id, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :id => message1.id }
  end

  should 'should get newer mediations' do
    mediation1 = create_mediation(hub, user, community)
    mediation2 = create_mediation(hub, user, community)
    mediation3 = create_mediation(hub, user, community)
    xhr :get, :newer_articles, { :latest_post => mediation2.id, :hub => hub.id }
    assert_tag :tag => 'li', :attributes => { :id => mediation3.id }
  end

  should 'should promote user' do
    login_as(user.user.login)
    visitor = create_user('visitor').person
    xhr :post, :promote_user, { :hub => hub.id, :user => visitor.id }
    response = JSON.parse(@response.body)
    assert_equal true, response['ok']
  end

  should 'should pin message' do
    login_as(user.user.login)
    message = create_message( hub, user )
    xhr :post, :pin_message, { :hub => hub.id, :message => message.id }
    response = JSON.parse(@response.body)
    assert_equal true, response['ok']
  end

end

