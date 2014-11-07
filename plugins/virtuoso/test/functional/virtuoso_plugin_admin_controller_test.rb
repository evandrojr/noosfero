require File.dirname(__FILE__) + '/../test_helper'

class VirtuosoPluginAdminControllerTest < ActionController::TestCase

  def setup
    @environment = Environment.default
    @profile = create_user('profile').person
    login_as(@profile.identifier)
  end

  attr_reader :environment

  should 'save virtuoso plugin settings' do
    post :index, :settings => {'virtuoso_uri' => 'http://virtuoso.noosfero.com',
                               'virtuoso_username' => 'username',
                               'virtuoso_password' => 'password',
                               'dspace_uri' => 'http://dspace.noosfero.com'}
    @settings = Noosfero::Plugin::Settings.new(environment.reload, VirtuosoPlugin)
    assert_equal 'http://virtuoso.noosfero.com', @settings.settings[:virtuoso_uri]
    assert_equal 'username', @settings.settings[:virtuoso_username]
    assert_equal 'password', @settings.settings[:virtuoso_password]
    assert_equal 'http://dspace.noosfero.com', @settings.settings[:dspace_uri]
    assert_redirected_to :action => 'index'
  end

  should 'redirect to index after save' do
    post :index, :settings => {"virtuoso_uri" => 'http://virtuoso.noosfero.com'}
    assert_redirected_to :action => 'index'
  end

  should 'create delayed job to start harvest on force action' do
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment)
    assert !harvest.find_job.present?
    get :force_harvest
    assert harvest.find_job.present?
  end

end
