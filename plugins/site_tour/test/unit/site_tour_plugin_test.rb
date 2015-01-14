require File.dirname(__FILE__) + '/../test_helper'

class SiteTourPluginTest < ActiveSupport::TestCase

  def setup
    @plugin = SiteTourPlugin.new
  end

  attr_accessor :plugin

  should 'include site tour plugin actions in user data for logged in users' do
    expects(:logged_in?).returns(true)
    person = create_user('testuser').person
    person.site_tour_plugin_actions = ['login', 'navigation']
    expects(:user).returns(person)

    assert_equal({:site_tour_plugin_actions => ['login', 'navigation']}, instance_eval(&plugin.user_data_extras))
  end

  should 'return empty hash when user is not logged in' do
    expects(:logged_in?).returns(false)
    assert_equal({}, instance_eval(&plugin.user_data_extras))
  end

  should 'include javascript related to tour instructions if file exists' do
    file = '/plugins/site_tour/tour/pt/tour.js'
    expects(:language).returns('pt')
    File.expects(:exists?).with(Rails.root.join("public#{file}").to_s).returns(true)
    expects(:javascript_include_tag).with(file)
    instance_exec(&plugin.body_ending)
  end

  should 'not include javascript file do not exists' do
    file = '/plugins/site_tour/tour/pt/tour.js'
    expects(:language).returns('pt')
    File.expects(:exists?).with(Rails.root.join("public#{file}").to_s).returns(false)
    assert_equal "", instance_exec(&plugin.body_ending)
  end

end
