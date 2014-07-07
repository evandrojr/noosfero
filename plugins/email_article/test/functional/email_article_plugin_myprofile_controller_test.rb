require File.dirname(__FILE__) + '/../../../../test/test_helper'

class EmailArticlePluginMyprofileControllerTest < ActionController::TestCase

  def setup
    Environment.delete_all
    @environment = Environment.new(:name => 'testenv', :is_default => true)
    @environment.enabled_plugins = ['EmailArticlePlugin']
    @environment.save!
  end

  should 'be able to deliver mail as profile admin' do
    @profile = Community.create!(:name => 'Sample community', :identifier => 'sample-community')
    @user = create_user('testinguser')
    login_as(@user.login)
    @profile.add_admin(@user.person)
    @article = @profile.articles.create!(:name => 'a test article', :last_changed_by => @user.person)
    @article.save
    get :send_email, :profile => @profile.identifier, :id => @article.id
    assert_response :success
  end

  should 'deny access to email article unless if profile admin' do
    @profile = Community.create!(:name => 'Another community', :identifier => 'another-community')
    @user = create_user('user-out-of-the-community')
    login_as(@user.login)
    @article = @profile.articles.create!(:name => 'a test article', :last_changed_by => @user.person)
    @article.save
    get :send_email, :profile => @profile.identifier, :id => @article.id
    assert_response 403
  end

end






