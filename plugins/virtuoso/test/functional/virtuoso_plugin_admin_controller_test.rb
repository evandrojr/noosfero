require File.dirname(__FILE__) + '/../test_helper'

class VirtuosoPluginAdminControllerTest < ActionController::TestCase

  attr_reader :environment
  
  def setup
    @environment = Environment.default
    @profile = create_user('profile').person
    login_as(@profile.identifier)
    post :index, :settings => mock_settings
  end
  
  def mock_settings
    {
      :virtuoso_uri=>"http://virtuoso.noosfero.com",
                      :virtuoso_username=>"username", :virtuoso_password=>"password",
                      :virtuoso_readonly_username=>"username",
                      :virtuoso_readonly_password=>"password",
                      :dspace_servers=>[
                        {"dspace_uri"=>"http://dspace1.noosfero.com"},
                        {"dspace_uri"=>"http://dspace2.noosfero.com"},
                        {"dspace_uri"=>"http://dspace3.noosfero.com"}
                      ]
    }
  end                 

  should 'save virtuoso plugin settings' do
    @settings = Noosfero::Plugin::Settings.new(environment.reload, VirtuosoPlugin)
    assert_equal 'http://virtuoso.noosfero.com', @settings.settings[:virtuoso_uri]
    assert_equal 'username', @settings.settings[:virtuoso_username]
    assert_equal 'password', @settings.settings[:virtuoso_password]
    assert_equal 'http://dspace1.noosfero.com', @settings.settings[:dspace_servers][0][:dspace_uri]
    assert_equal 'http://dspace2.noosfero.com', @settings.settings[:dspace_servers][1][:dspace_uri]
    assert_equal 'http://dspace3.noosfero.com', @settings.settings[:dspace_servers][2][:dspace_uri]
    assert_redirected_to :action => 'index'
  end

  should 'redirect to index after save' do
    post :index, :settings => mock_settings
    assert_redirected_to :action => 'index'
  end

  should 'create delayed job to start harvest on force action' do
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment)
    assert !harvest.find_job.present?
    get :force_harvest
    assert harvest.find_job.present?
  end

  should 'force harvest from start' do
    get :force_harvest, :from_start => true
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment)
    assert harvest.find_job.present?
    assert_equal nil, harvest.settings.last_harvest
  end

end
