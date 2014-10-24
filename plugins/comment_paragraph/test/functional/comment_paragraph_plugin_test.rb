require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/comment_paragraph_plugin_admin_controller'

# Re-raise errors caught by the controller.
class CommentParagraphPluginAdminController; def rescue_action(e) raise e end; end

class CommentParagraphPluginAdminControllerTest < ActionController::TestCase

  def setup
    @environment = Environment.default
    user_login = create_admin_user(@environment)
    login_as(user_login)
    @environment.enabled_plugins = ['CommentParagraphPlugin']
    @environment.save!
    @plugin_settings = Noosfero::Plugin::Settings.new(@environment, CommentParagraphPlugin)
  end

  should 'access index action' do
    get :index
    assert_template 'index'
    assert_response :success
  end

  should 'update comment paragraph plugin settings' do
    assert_nil @plugin_settings.get_setting(:auto_marking_article_types)
    post :index, :settings => { :auto_marking_article_types => ['TinyMceArticle'] }
    @environment.reload
    assert_not_nil @plugin_settings.get_setting(:auto_marking_article_types)
  end

  should 'get article types previously selected' do
    post :index, :settings => { :auto_marking_article_types => ['TinyMceArticle', 'TextileArticle'] }
    get :index
    assert_tag :input, :attributes => { :value => 'TinyMceArticle' }
    assert_tag :input, :attributes => { :value => 'TextileArticle' }
  end

end
