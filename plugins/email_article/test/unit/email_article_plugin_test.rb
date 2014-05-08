require File.dirname(__FILE__) + '/../test_helper'

class EmailArticlePluginTest < ActiveSupport::TestCase

  def setup
    @plugin = EmailArticlePlugin.new
  end

  should 'be a noosfero plugin' do
    assert_kind_of Noosfero::Plugin, @plugin
  end

  should 'have name' do
    assert_equal 'Relevant Content Plugin', EmailArticlePlugin.plugin_name
  end

  should 'have description' do
    assert_equal  _("A plugin that lists the most accessed, most commented, most liked and most disliked contents."), EmailArticlePlugin.plugin_description
  end

  should 'have stylesheet' do
    assert @plugin.stylesheet?
  end

end
