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

end
