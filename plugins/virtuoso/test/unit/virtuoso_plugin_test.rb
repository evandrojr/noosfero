require File.dirname(__FILE__) + '/../test_helper'

class VirtuosoPluginTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @plugin = VirtuosoPlugin.new
  end

  attr_reader :plugin

  should 'define a new content' do
    assert_equal [VirtuosoPlugin::TriplesTemplate], plugin.content_types
  end

end
