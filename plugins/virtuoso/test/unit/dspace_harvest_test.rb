require File.dirname(__FILE__) + '/../test_helper'

class DspaceHarvestTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
  end

  attr_reader :environment

  def mock_settings
    { :virtuoso_uri=>"http://virtuoso.noosfero.com",
      :virtuoso_username=>"username",
      :virtuoso_password=>"password",
      :virtuoso_readonly_username=>"readonly_username",
      :virtuoso_readonly_password=>"readonly_password",
      :dspace_servers=>[
        {"dspace_uri"=>"http://dspace1.noosfero.com"},
        {"dspace_uri"=>"http://dspace2.noosfero.com"},
        {"dspace_uri"=>"http://dspace3.noosfero.com"}
      ]
    }
  end

  should 'create delayed job when start' do
    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, mock_settings)
    @settings.save!
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, "http://dspace1.noosfero.com")
    assert !harvest.find_job.present?
    harvest.start
    assert harvest.find_job.present?
  end

  should 'not duplicate harvest job' do
    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, mock_settings)
    @settings.save!
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, "http://dspace1.noosfero.com")
    assert_difference "harvest.find_job.count", 1 do
      5.times { harvest.start }
    end
  end

  should 'try to harvest all dspaces from start without any setting' do
    VirtuosoPlugin::DspaceHarvest.harvest_all(environment, true)
  end

  should 'try to harvest all dspaces from start with mock configuration' do
    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, mock_settings)
    @settings.save!
    VirtuosoPlugin::DspaceHarvest.harvest_all(environment, true)
  end

  should 'try to harvest all dspaces without any setting' do
    VirtuosoPlugin::DspaceHarvest.harvest_all(environment, false)
  end

  should 'try to harvest all dspaces with mock configuration' do
    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, mock_settings)
    @settings.save!
    VirtuosoPlugin::DspaceHarvest.harvest_all(environment, false)
  end

end
