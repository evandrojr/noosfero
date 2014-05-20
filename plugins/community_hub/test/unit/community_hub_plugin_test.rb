require File.dirname(__FILE__) + '/../test_helper'

class CommunityHubPluginTest < ActiveSupport::TestCase

  def setup
    @plugin = CommunityHubPlugin.new
    @profile = fast_create(Community)
    @params = {}
    @plugin.stubs(:context).returns(self)
  end

  attr_reader :profile, :params

  should 'has name' do
    assert CommunityHubPlugin.plugin_name
  end

  should 'describe yourself' do
    assert CommunityHubPlugin.plugin_description
  end

  should 'has stylesheet' do
    assert @plugin.stylesheet?
  end

  should 'return Hub as a content type if profile is a community' do
    assert_includes @plugin.content_types, CommunityHubPlugin::Hub
  end

  should 'do not return Hub as a content type if profile is not a community' do
    @profile = Organization.new
    assert_not_includes @plugin.content_types, CommunityHubPlugin::Hub
  end

  should 'do not return Hub as a content type if there is a parent' do
    parent = fast_create(Blog, :profile_id => @profile.id)
    @params[:parent_id] = parent.id
    assert_not_includes @plugin.content_types, CommunityHubPlugin::Hub
  end

  should 'return true at content_remove_new if page is a Hub' do
    assert @plugin.content_remove_new(CommunityHubPlugin::Hub.new)
  end

  should 'return false at content_remove_new if page is not a Hub' do
    assert !@plugin.content_remove_new(Article.new)
  end

end
