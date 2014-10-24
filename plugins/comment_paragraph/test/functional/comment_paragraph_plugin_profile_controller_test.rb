require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../controllers/profile/comment_paragraph_plugin_profile_controller'

# Re-raise errors caught by the controller.
class CommentParagraphPluginProfileController; def rescue_action(e) raise e end; end

class CommentParagraphPluginProfileControllerTest < ActionController::TestCase

  def setup
    @controller = CommentParagraphPluginProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @profile = create_user('testuser').person
    @article = profile.articles.build(:name => 'test')
    @article.save!
  end
  attr_reader :article
  attr_reader :profile

  should 'be able to show paragraph comments' do
    comment = fast_create(Comment, :source_id => article, :author_id => profile, :title => 'a comment', :body => 'lalala', :paragraph_id => 0)
    xhr :get, :view_comments, :profile => @profile.identifier, :article_id => article.id, :paragraph_id => 0
    assert_template 'comment_paragraph_plugin_profile/view_comments'
    assert_match /comments_list_paragraph_0/, @response.body
    assert_match /\"comment-count-0\", \"1\"/, @response.body
  end

  should 'do not show global comments' do
    fast_create(Comment, :source_id => article, :author_id => profile, :title => 'global comment', :body => 'global', :paragraph_id => nil)
    fast_create(Comment, :source_id => article, :author_id => profile, :title => 'a comment', :body => 'lalala', :paragraph_id => 0)
    xhr :get, :view_comments, :profile => @profile.identifier, :article_id => article.id, :paragraph_id => 0
    assert_template 'comment_paragraph_plugin_profile/view_comments'
    assert_match /comments_list_paragraph_0/, @response.body
    assert_match /\"comment-count-0\", \"1\"/, @response.body
  end

  should 'be able to show all comments of a paragraph' do
    comment1 = fast_create(Comment, :created_at => Time.now - 1.days, :source_id => article, :author_id => profile, :title => 'a comment', :body => 'a comment', :paragraph_id => 0)
    comment2 = fast_create(Comment, :created_at => Time.now - 2.days, :source_id => article, :author_id => profile, :title => 'b comment', :body => 'b comment', :paragraph_id => 0)
    comment3 = fast_create(Comment, :created_at => Time.now - 3.days, :source_id => article, :author_id => profile, :title => 'c comment', :body => 'c comment', :paragraph_id => 0)
    comment4 = fast_create(Comment, :created_at => Time.now - 4.days, :source_id => article, :author_id => profile, :title => 'd comment', :body => 'd comment', :paragraph_id => 0)
    xhr :get, :view_comments, :profile => @profile.identifier, :article_id => article.id, :paragraph_id => 0
    assert_match /a comment/, @response.body
    assert_match /b comment/, @response.body
    assert_match /c comment/, @response.body
    assert_match /d comment/, @response.body
  end

end
