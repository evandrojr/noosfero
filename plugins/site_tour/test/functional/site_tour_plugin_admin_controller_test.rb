require File.dirname(__FILE__) + '/../test_helper'

class SiteTourPluginAdminControllerTest < ActionController::TestCase

  def setup
    @environment = Environment.default
    @profile = create_user('profile').person
    login_as(@profile.identifier)
  end

  attr_reader :environment

  should 'parse csv and save actions array in plugin settings' do
    actions_csv = "en,tour_plugin,.tour-button,Click"
    post :index, :settings => {"actions_csv" => actions_csv}
    @settings = Noosfero::Plugin::Settings.new(environment.reload, SiteTourPlugin)
    assert_equal [{:language => 'en', :group_name => 'tour_plugin', :selector => '.tour-button', :description => 'Click'}], @settings.actions
  end

  should 'parse csv and save group triggers array in plugin settings' do
    group_triggers_csv = "tour_plugin,.tour-button,mouseenter"
    post :index, :settings => {"group_triggers_csv" => group_triggers_csv}
    @settings = Noosfero::Plugin::Settings.new(environment.reload, SiteTourPlugin)
    assert_equal [{:group_name => 'tour_plugin', :selector => '.tour-button', :event => 'mouseenter'}], @settings.group_triggers
  end

  should 'do not store actions_csv' do
    actions_csv = "en,tour_plugin,.tour-button,Click"
    post :index, :settings => {"actions_csv" => actions_csv}
    @settings = Noosfero::Plugin::Settings.new(environment.reload, SiteTourPlugin)
    assert_equal nil, @settings.settings[:actions_csv]
  end

  should 'convert actions array to csv to enable user edition' do
    @settings = Noosfero::Plugin::Settings.new(environment.reload, SiteTourPlugin)
    @settings.actions = [{:language => 'en', :group_name => 'tour_plugin', :selector => '.tour-button', :description => 'Click'}]
    @settings.save!

    get :index
    assert_tag :tag => 'textarea', :content => "\nen,tour_plugin,.tour-button,Click\n"
  end

end
