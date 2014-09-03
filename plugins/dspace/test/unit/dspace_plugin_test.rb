require File.dirname(__FILE__) + '/../test_helper'

class DspacePluginTest < ActiveSupport::TestCase

  def setup
    @plugin = DspacePlugin.new
  end

  should 'be a noosfero plugin' do
    assert_kind_of Noosfero::Plugin, @plugin
  end

  should 'have name' do
    assert_equal 'Relevant Content Plugin', DspacePlugin.plugin_name
  end

  should 'have description' do
    assert_equal  _("A plugin that lists the most accessed, most commented, most liked and most disliked contents."), DspacePlugin.plugin_description
  end

  should 'have stylesheet' do
    assert @plugin.stylesheet?
  end

  should "return DspaceBlock in extra_blocks class method" do
    assert  DspacePlugin.extra_blocks.keys.include?(DspacePlugin::DspaceBlock)
  end

end
