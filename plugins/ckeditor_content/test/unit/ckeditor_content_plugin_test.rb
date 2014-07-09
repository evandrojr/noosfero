require File.dirname(__FILE__) + '/../test_helper'

class CkeditorContentPluginTest < ActiveSupport::TestCase

  def setup
    @plugin = CkeditorContentPlugin.new
  end

  should 'has name' do
    assert CkeditorContentPlugin.plugin_name
  end

  should 'describe yourself' do
    assert CkeditorContentPlugin.plugin_description
  end

  should 'has not stylesheet' do
    assert !@plugin.stylesheet?
  end

  should 'return CkeditorArticle as a content type' do
    assert_includes @plugin.content_types, CkeditorContentPlugin::CkeditorArticle
  end

  should 'include ckeditor.js library' do
    assert_includes @plugin.js_files, '/javascripts/ckeditor/ckeditor.js'
  end

end
