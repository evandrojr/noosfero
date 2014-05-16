require File.dirname(__FILE__) + '/../test_helper'

class EmailArticlePluginTest < ActiveSupport::TestCase

  def setup
    @plugin = EmailArticlePlugin.new
  end

  should 'be a noosfero plugin' do
    assert_kind_of Noosfero::Plugin, @plugin
  end

  should 'have name' do
    assert_equal 'Email Article to Community Members Plugin', EmailArticlePlugin.plugin_name
  end

  should 'have description' do
    assert_equal  _("A plugin that emails an article to the members of the community"), EmailArticlePlugin.plugin_description
  end

end
