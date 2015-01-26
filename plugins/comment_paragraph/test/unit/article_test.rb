require File.dirname(__FILE__) + '/../test_helper'
require 'benchmark'

class ArticleTest < ActiveSupport::TestCase

  def setup
    profile = fast_create(Community)
    @article = fast_create(Article, :profile_id => profile.id)
    @environment = Environment.default
    @environment.enable_plugin(CommentParagraphPlugin)
  end

  attr_reader :article, :environment

  should 'return paragraph comments from article' do
    comment1 = fast_create(Comment, :paragraph_uuid => 1, :source_id => article.id)
    comment2 = fast_create(Comment, :paragraph_uuid => nil, :source_id => article.id)
    assert_equal [comment1], article.paragraph_comments
  end

  should 'allow save if comment paragraph macro is not removed for paragraph with comments' do
    article.body = "<div class=\"macro\" data-macro-paragraph_uuid=0></div>"
    comment1 = fast_create(Comment, :paragraph_uuid => 0, :source_id => article.id)
    assert article.save
  end

  should 'not parse html if the plugin is not enabled' do
    article.body = "<p>paragraph 1</p><p>paragraph 2</p>"
    environment.disable_plugin(CommentParagraphPlugin)
    assert !environment.plugin_enabled?(CommentParagraphPlugin)
    article.save!
    assert_equal "<p>paragraph 1</p><p>paragraph 2</p>", article.body
  end

  should 'parse html if the plugin is not enabled' do
    article.body = "<p>paragraph 1</p><p>paragraph 2</p>"
    article.expects(:comment_paragraph_plugin_enabled?).returns(true)
    article.save!
    assert_match /data-macro='comment_paragraph_plugin\/allow_comment'/, article.body
  end

end
