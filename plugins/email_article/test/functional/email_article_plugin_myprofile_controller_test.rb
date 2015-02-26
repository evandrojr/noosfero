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
    @article = @profile.articles.create!(:name => 'a test article')
    @article.author = @user.person
    @article.save
    get :send_email, :profile => @profile.identifier, :id => @article.id
    assert_response :success
  end

  should 'deny access to email article unless if profile admin' do
    @profile = Community.create!(:name => 'Another community', :identifier => 'another-community')
    @user = create_user('user-out-of-the-community')
    login_as(@user.login)
    @article = @profile.articles.create!(:name => 'a test article')
    @article.author = @user.person
    @article.save
    get :send_email, :profile => @profile.identifier, :id => @article.id
    assert_response 403
  end

  should 'show button at article_toolbar_extra_buttons' do
    @profile = Community.create!(:name => 'Another community', :identifier => 'another-community')
    @user = create_user('user-out-of-the-community')
    login_as(@user.login)
    @article = TextArticle.new
    @article.name = 'a test article'
    @article.profile = @profile
    @article.author = @user.person
    @article.save
    @plugin = EmailArticlePlugin.new
    @plugin.stubs(:link_to_remote).returns(true)
    send_mail_button = @plugin.article_toolbar_extra_buttons
    self.stubs(:profile).returns(@profile)
    self.stubs(:user).returns(@user)
    self.stubs(:page).returns(@article)
    @user.stubs(:is_admin?).returns(true)
    self.stubs(:link_to_remote).returns("send mail button")
    html = self.instance_eval(&send_mail_button)
    assert_equal html, "send mail button"
  end  
  
end
