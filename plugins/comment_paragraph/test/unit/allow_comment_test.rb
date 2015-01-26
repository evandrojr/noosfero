require File.dirname(__FILE__) + '/../test_helper'

class AllowCommentTest < ActiveSupport::TestCase

  def setup
    @macro = CommentParagraphPlugin::AllowComment.new
  end

  attr_reader :macro

  should 'have a configuration' do
    assert CommentParagraphPlugin::AllowComment.configuration
  end

  should 'parse contents to include comment paragraph view' do
    profile = fast_create(Community)
    article = fast_create(Article, :profile_id => profile.id)
    comment = fast_create(Comment, :paragraph_uuid => 1, :source_id => article.id)
    inner_html = 'inner'
    content = macro.parse({:paragraph_uuid => comment.paragraph_uuid}, inner_html, article)
    expects(:controller).returns(ContentViewerController.new)

    expects(:render).with({:partial => 'comment_paragraph_plugin_profile/comment_paragraph', :locals => {:paragraph_uuid => comment.paragraph_uuid, :article_id => article.id, :inner_html => inner_html, :count => 1, :profile_identifier => profile.identifier} })
    instance_eval(&content)
  end

  should 'not parse contents outside content viewer controller' do
    profile = fast_create(Community)
    article = fast_create(Article, :profile_id => profile.id)
    comment = fast_create(Comment, :paragraph_uuid => 1, :source_id => article.id)
    inner_html = 'inner'
    content = macro.parse({:paragraph_uuid => comment.paragraph_uuid}, inner_html, article)
    expects(:controller).returns(HomeController.new)

    assert_equal 'inner', instance_eval(&content)
  end

end
