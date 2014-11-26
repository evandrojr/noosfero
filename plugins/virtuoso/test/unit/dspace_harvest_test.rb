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
        {"dspace_uri"=>"http://dspace1.noosfero.com","last_harvest" => Time.now.utc },
        {"dspace_uri"=>"http://dspace2.noosfero.com"},
        {"dspace_uri"=>"http://dspace3.noosfero.com", "last_harvest" => Time.now.utc},
        {"dspace_uri"=>"http://dspace4.noosfero.com", "last_harvest" => nil},
        {"dspace_uri"=>"http://dspace5.noosfero.com", "last_harvest" => Time.now.utc},
      ]
    }
  end

  should 'initialize with dspace_uri' do
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, {"dspace_uri"=>"http://dspace1.noosfero.com"})
    assert harvest.dspace_uri, "http://dspace1.noosfero.com"
  end

  should 'initialize with dspace_uri and last_harvest' do
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, {"dspace_uri"=>"http://dspace9.noosfero.com", "last_harvest" => 5})
    assert harvest.dspace_uri, "http://dspace9.noosfero.com"
    assert harvest.last_harvest, 5
  end

  should 'save_harvest_time_settings' do
    Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, mock_settings)
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, {"dspace_uri"=>"http://dspace5.noosfero.com", "last_harvest" => 9})
    assert harvest.last_harvest, 9
    harvest.save_harvest_time_settings(10)
    Noosfero::Plugin::Settings.new(environment.reload, VirtuosoPlugin)
    assert harvest.last_harvest, 10
  end

  should 'create delayed job when start' do
    settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, mock_settings)
    settings.save!
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, {"dspace_uri"=>"http://dspace1.noosfero.com", "last_harvest" => 5})
    assert !harvest.find_job.present?
    harvest.start
    assert harvest.find_job.present?
  end

  should 'not duplicate harvest job' do
    settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, mock_settings)
    settings.save!
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, {"dspace_uri"=>"http://dspace1.noosfero.com", "last_harvest" => 5})
    assert_difference "harvest.find_job.count", 1 do
      5.times { harvest.start }
    end
  end

  should 'try to harvest all dspaces from start without any setting' do
    VirtuosoPlugin::DspaceHarvest.harvest_all(environment, true)
  end

  should 'try to harvest all dspaces from start with mock configuration' do
    settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, mock_settings)
    settings.save!
    VirtuosoPlugin::DspaceHarvest.harvest_all(environment, true)
  end

  should 'try to harvest all dspaces without any setting' do
    VirtuosoPlugin::DspaceHarvest.harvest_all(environment, false)
  end

  should 'try to harvest all dspaces with mock configuration' do
    settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, mock_settings)
    settings.save!
    VirtuosoPlugin::DspaceHarvest.harvest_all(environment, false)
  end
  
  should 'update last_harvest after harvert from start' do
    settings =
    { :virtuoso_uri=>"http://virtuoso.set_at_etc_hosts",
      :virtuoso_username=>"dba",
      :virtuoso_password=>"dba",
      :virtuoso_readonly_username=>"dba",
      :virtuoso_readonly_password=>"dba",
      :dspace_servers=>[
          {"dspace_uri"=>"http://dspace.set_at_etc_hosts","last_harvest" =>  Time.now.utc }
        ]
    }    
    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, settings)
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, {"dspace_uri"=>"http://virtuoso.set_at_etc_hosts" })
    puts "last_harvest before #{harvest.last_harvest}"    
    harvest.run
    puts "last_harvest after #{harvest.last_harvest}"
    asser
  end

end
