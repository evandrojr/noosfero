require_relative '../test_helper'
include ActionView::Helpers::FormTagHelper

class CommentParagraphPluginTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @plugin = CommentParagraphPlugin.new
    @user = create_user('testuser').person
  end

  attr_reader :environment, :plugin, :user

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

  should 'not add comment_paragraph_selected_area if comment_paragraph_selected_area is blank' do
    comment = Comment.new
    comment.comment_paragraph_selected_area = ""
    comment.paragraph_uuid = 2
    cpp = CommentParagraphPlugin.new
    prok = cpp.comment_form_extra_contents({:comment=>comment, :paragraph_uuid=>4})
    assert_nil /comment_paragraph_selected_area/.match(prok.call.inspect)
  end

  should 'display button to toggle comment paragraph for users which can edit the article' do
    article = fast_create(Article)
    article.expects(:comment_paragraph_plugin_enabled?).returns(true)
    article.expects(:allow_edit?).with(user).returns(true)

    content = plugin.article_header_extra_contents(article)
    expects(:button).once
    instance_eval(&content)
  end

  should 'not display button to toggle comment paragraph for users which can not edit the article' do
    article = fast_create(Article)
    article.expects(:comment_paragraph_plugin_enabled?).returns(true)
    article.expects(:allow_edit?).with(user).returns(false)

    content = plugin.article_header_extra_contents(article)
    assert_equal nil, instance_eval(&content)
  end

  should 'not display button to toggle comment paragraph if plugin is not enabled' do
    article = fast_create(Article)
    article.expects(:comment_paragraph_plugin_enabled?).returns(false)

    assert_equal nil, plugin.article_header_extra_contents(article)
  end

end
