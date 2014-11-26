#require File.dirname(__FILE__) + '/../test_helper.rb'
#
#class DspaceTest < ActiveSupport::TestCase
#
#  def setup
#    @environment = Environment.default
#  end
#  
#  attr_reader :environment  
#
#
#  should 'update last_harvest after harvert' do
#    time = Time.now.utc
#    settings =
#    { :virtuoso_uri=>"http://hom.virtuoso.participa.br",
#      :virtuoso_username=>"dba",
#      :virtuoso_password=>"dba",
#      :virtuoso_readonly_username=>"dba",
#      :virtuoso_readonly_password=>"dba",
#      :dspace_servers=>[
#          {"dspace_uri"=>"http://hom.dspace.participa.br"}
#        ]
#    }
#    @settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, settings)
#    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, {"dspace_uri"=>"http://hom.dspace.participa.br" })
#    harvest.run
#    assert_not_equal harvest.last_harvest, nil
#    Noosfero::Plugin::Settings.new(environment.reload, VirtuosoPlugin)
#    assert_not_equal harvest.last_harvest, nil
#    assert_not_equal harvest.last_harvest, Time.now.utc
#  end  
#  
#end