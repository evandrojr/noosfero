require File.dirname(__FILE__) + '/../test_helper'

class CmsController; def rescue_action(e) raise e end; end

class CmsControllerTest < ActionController::TestCase

  def setup
    @controller = CmsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    user = create_user('testinguser')

    @environment = user.environment

    @community = Community.create!(
      :name => 'Sample community',
      :identifier => 'sample-community',
      :environment => @environment
    )

    @community.add_admin(user.person)

    @community.save!

    @hub = CommunityHubPlugin::Hub.new(
      :abstract => 'abstract',
      :body => 'body',
      :name => 'test-hub',
      :profile => @community,
      :last_changed_by_id => user
    )

    @hub.save!

    login_as(user.login)

  end

  should 'be able to edit hub settings' do
    get :edit, :id => @hub.id, :profile => @community.identifier
    assert_tag :tag => 'input', :attributes => { :id => 'article_name' }
    assert_tag :tag => 'textarea', :attributes => { :id => 'article_body' }
    assert_tag :tag => 'input', :attributes => { :id => 'article_twitter_enabled' }
    assert_tag :tag => 'input', :attributes => { :id => 'article_twitter_hashtags' }
    assert_tag :tag => 'input', :attributes => { :id => 'article_facebook_enabled' }
    assert_tag :tag => 'input', :attributes => { :id => 'article_facebook_hashtag' }
    assert_tag :tag => 'input', :attributes => { :id => 'article_facebook_access_token' }
  end

  should 'be able to save hub' do
    get :edit, :id => @hub.id, :profile => @community.identifier
    post :edit, :id => @hub.id, :profile => @community.identifier, :article => {
      :name => 'changed',
      :body => 'changed',
      :twitter_enabled => true,
      :twitter_hashtags => 'changed',
      :facebook_enabled => true,
      :facebook_hashtag => 'changed',
      :facebook_access_token => 'changed'
    }
    @hub.reload
    assert_equal 'changed', @hub.name
    assert_equal 'changed', @hub.body
    assert_equal true, @hub.twitter_enabled
    assert_equal 'changed', @hub.twitter_hashtags
    assert_equal true, @hub.facebook_enabled
    assert_equal 'changed', @hub.facebook_hashtag
    assert_equal 'changed', @hub.facebook_access_token
  end

end

