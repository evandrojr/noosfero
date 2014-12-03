require File.dirname(__FILE__) + '/../test_helper'
include ActionView::Helpers::FormTagHelper

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

  should 'not add comment_paragraph_selected_area if comment_paragraph_selected_area is blank' do
    comment = Comment.new
    comment.comment_paragraph_selected_area = ""
    comment.paragraph_id = 2
    cpp = CommentParagraphPlugin.new
    prok = cpp.comment_form_extra_contents({:comment=>comment, :paragraph_id=>4})
    assert_nil /comment_paragraph_selected_area/.match(prok.call.inspect)
  end

end
