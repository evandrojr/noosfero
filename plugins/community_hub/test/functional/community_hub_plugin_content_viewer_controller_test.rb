require File.dirname(__FILE__) + '/../test_helper'
require 'content_viewer_controller'

class ContentViewerController; def rescue_action(e) raise e end; end

class ContentViewerControllerTest < ActionController::TestCase

  all_fixtures

  def setup
    @controller = ContentViewerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @user = create_user('testinguser').person

    @environment = @user.environment

    @community = Community.create!(
      :name => 'Sample community',
      :identifier => 'sample-community',
      :environment => @environment
    )

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
  should 'display live tab' do
    get :view_page, @hub.url
    assert_tag :tag => 'div', :attributes => { :id => 'left-tab' }
  end

  should 'display mediation tab' do
    get :view_page, @hub.url
    assert_tag :tag => 'div', :attributes => { :id => 'right-tab' }
  end

  should 'display auto scroll checkbox for live stream content' do
    get :view_page, @hub.url
    assert_tag :tag => 'div', :attributes => { :id => 'left-tab' }, :descendant => {
                  :tag => 'span', :descendant => {
                    :tag => 'input', :attributes => { :id => 'auto_scrolling', :type => 'checkbox' }
                  }
                }
  end

  should 'not display auto scroll setting for mediation content' do
    get :view_page, @hub.url
    assert_no_tag :tag => 'div', :attributes => { :id => 'right-tab' }, :descendant => {
                    :tag => 'span', :descendant => {
                      :tag => 'input', :attributes => { :id => 'auto_scrolling', :type => 'checkbox' }
                    }
                  }
  end

  should 'not display message form if user is not logged' do
    get :view_page, @hub.url
    assert_no_tag :tag => 'div', :attributes => { :class => 'form-message' }
  end

  should 'not display mediation form if user is not loged' do
    get :view_page, @hub.url
    assert_no_tag :tag => 'div', :attributes => { :class => 'form-mediation' }
  end

  should 'display message form if user is logged' do
    user = create_user('visitor')
    login_as(user.login)
    get :view_page, @hub.url
    assert_tag :tag => 'div', :attributes => { :class => 'form-message' }
  end

  should 'display mediation form if user is logged and is hub''s mediator' do
    login_as(user.user.login)
    get :view_page, @hub.url
    assert_tag :tag => 'div', :attributes => { :class => 'form-mediation' }
  end

  should 'not display mediation form if user is logged but is not hub''s mediator' do
    visitor = create_user('visitor')
    login_as(visitor.login)
    assert_no_tag :tag => 'div', :attributes => { :class => 'form-mediation' }
  end

  should 'display link to hub''s settings if user is mediator' do
    login_as(user.user.login)
    get :view_page, @hub.url
    assert_tag :tag => 'div', :attributes => { :class => 'settings' }
  end

  should 'not display link to hub''s settings if user is not mediator' do
    visitor = create_user('visitor')
    login_as(visitor.login)
    get :view_page, @hub.url
    assert_no_tag :tag => 'div', :attributes => { :class => 'settings' }
  end

end
