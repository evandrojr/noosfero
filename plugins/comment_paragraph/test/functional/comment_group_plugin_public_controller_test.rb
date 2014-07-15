require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../controllers/public/comment_paragraph_plugin_public_controller'

# Re-raise errors caught by the controller.
class CommentParagraphPluginPublicController; def rescue_action(e) raise e end; end

class CommentParagraphPluginPublicControllerTest < ActionController::TestCase

  def setup
    @controller = CommentParagraphPluginPublicController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @profile = create_user('testuser').person
    @article = profile.articles.build(:name => 'test')
    @article.save!
  end
  attr_reader :article
  attr_reader :profile

  should 'be able to return paragraph_id for a comment' do
    comment = fast_create(Comment, :source_id => article, :author_id => profile, :title => 'a comment', :body => 'lalala', :paragraph_id => 0)
    xhr :get, :comment_paragraph, :id => comment.id
    assert_match /\{\"paragraph_id\":0\}/, @response.body
  end

  should 'return paragraph_id=null for a global comment' do
    comment = fast_create(Comment, :source_id => article, :author_id => profile, :title => 'a comment', :body => 'lalala' )
    xhr :get, :comment_paragraph, :id => comment.id
    assert_match /\{\"paragraph_id\":null\}/, @response.body
  end

end
