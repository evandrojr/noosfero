require File.dirname(__FILE__) + '/../test_helper'
require 'benchmark'

class ArticleTest < ActiveSupport::TestCase

  def setup
    @profile = fast_create(Community)
    @article = fast_create(TextArticle, :profile_id => profile.id)
    @environment = Environment.default
    @environment.enable_plugin(CommentParagraphPlugin)
  end

  attr_reader :article, :environment, :profile

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
    article.comment_paragraph_plugin_activate = true
    article.save!
    assert_match /data-macro="comment_paragraph_plugin\/allow_comment"/, article.body
  end

  should 'do not remove macro div when disable comment paragraph' do
    article.body = "<p>paragraph 1</p><p>paragraph 2</p>"
    article.comment_paragraph_plugin_activate = true
    article.save!
    assert_match /data-macro="comment_paragraph_plugin\/allow_comment"/, article.body
    article.comment_paragraph_plugin_activate = false
    article.save!
    assert_match /data-macro="comment_paragraph_plugin\/allow_comment"/, article.body
  end

  should 'parse html when activate comment paragraph' do
    article.body = "<p>paragraph 1</p><p>paragraph 2</p>"
    article.comment_paragraph_plugin_activate = false
    article.save!
    assert_equal "<p>paragraph 1</p><p>paragraph 2</p>", article.body
    article.comment_paragraph_plugin_activate = true
    article.save!
    assert_match /data-macro="comment_paragraph_plugin\/allow_comment"/, article.body
  end

  should 'be enabled if plugin is enabled and article is a kind of TextArticle' do
    assert article.comment_paragraph_plugin_enabled?
  end

  should 'not be enabled if plugin is not enabled' do
    environment.disable_plugin(CommentParagraphPlugin)
    assert !article.comment_paragraph_plugin_enabled?
  end

  should 'not be enabled if article if not a kind of TextArticle' do
    article = fast_create(Article, :profile_id => profile.id)
    assert !article.comment_paragraph_plugin_enabled?
  end

  should 'not be activated by default' do
    article = fast_create(TextArticle, :profile_id => profile.id)
    assert !article.comment_paragraph_plugin_activated?
  end

  should 'be activated by default if it is enabled and activation mode is auto' do
    settings = Noosfero::Plugin::Settings.new(environment, CommentParagraphPlugin)
    settings.activation_mode = 'auto'
    settings.save!
    article = TextArticle.create!(:profile => profile, :name => 'title')
    assert article.comment_paragraph_plugin_activated?
  end

  should 'be activated when forced' do
    article.comment_paragraph_plugin_activate = true
    assert article.comment_paragraph_plugin_activated?
  end

  should 'not be activated if plugin is not enabled' do
    article.comment_paragraph_plugin_activate = true
    environment.disable_plugin(CommentParagraphPlugin)
    assert !article.comment_paragraph_plugin_enabled?
  end

end
