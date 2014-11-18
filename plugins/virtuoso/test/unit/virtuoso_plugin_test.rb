require File.dirname(__FILE__) + '/../test_helper'

class VirtuosoPluginTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @plugin = VirtuosoPlugin.new(self)
  end

  attr_reader :plugin, :environment

  should 'define a new content' do
    assert_equal [VirtuosoPlugin::TriplesTemplate], plugin.content_types
  end

  should 'create a client for virtuoso using admin account' do
    plugin.stubs(:settings).returns(mock)
    plugin.settings.expects(:virtuoso_uri)
    plugin.settings.expects(:virtuoso_username)
    plugin.settings.expects(:virtuoso_password)
    plugin.virtuoso_client
  end

  should 'create a client for virtuoso using a read-only account' do
    plugin.stubs(:settings).returns(mock)
    plugin.settings.expects(:virtuoso_uri)
    plugin.settings.expects(:virtuoso_readonly_username)
    plugin.settings.expects(:virtuoso_readonly_password)
    plugin.virtuoso_readonly_client
  end

  should 'has a default value for ontology mapping setting' do
    assert plugin.settings.ontology_mapping
  end

end
