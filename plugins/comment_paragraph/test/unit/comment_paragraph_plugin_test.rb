require File.dirname(__FILE__) + '/../test_helper'

class CommentParagraphPluginTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @plugin = CommentParagraphPlugin.new
  end

  attr_reader :environment, :plugin

  should 'have a name' do
    assert_not_equal Noosfero::Plugin.plugin_name, CommentParagraphPlugin::plugin_name
  end

  should 'describe yourself' do
    assert_not_equal Noosfero::Plugin.plugin_description, CommentParagraphPlugin::plugin_description
  end

  should 'have a js file' do
    assert !plugin.js_files.blank?
  end

  should 'have stylesheet' do
    assert plugin.stylesheet?
  end

  should 'have extra contents for comment form' do
    comment = fast_create(Comment, :paragraph_id => 1)
    content = plugin.comment_form_extra_contents({:comment => comment})
    expects(:hidden_field_tag).with('comment[paragraph_id]', comment.paragraph_id).once
    instance_eval(&content)
  end

  should 'do not have extra contents for comments without paragraph' do
    comment = fast_create(Comment, :paragraph_id => nil)
    content = plugin.comment_form_extra_contents({:comment => comment})
    assert_equal nil, instance_eval(&content)
  end

  should 'call without_paragraph for scope passed as parameter to unavailable_comments' do
    article = fast_create(Article)
    article.expects(:without_paragraph).once
    plugin.unavailable_comments(article)
  end

#FIXME Obsolete test
#
#  should 'filter_comments returns all the comments wihout paragraph of an article passed as parameter' do
#    article = fast_create(Article)
#    c1 = fast_create(Comment, :source_id => article.id, :paragraph_id => 1)
#    c2 = fast_create(Comment, :source_id => article.id)
#    c3 = fast_create(Comment, :source_id => article.id)
#
#    plugin = CommentParagraphPlugin.new
#    assert_equal [], [c2, c3] - plugin.filter_comments(article.comments)
#    assert_equal [], plugin.filter_comments(article.comments) - [c2, c3]
#  end

end
