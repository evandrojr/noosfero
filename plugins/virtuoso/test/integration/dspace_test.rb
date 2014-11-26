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
#  should 'list at least one record' do
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
#    settings = Noosfero::Plugin::Settings.new(environment, VirtuosoPlugin, settings)
#    harvest = VirtuosoPlugin::DspaceHarvest.new(environment, {"dspace_uri"=>"http://hom.dspace.participa.br"})
#    params = harvest.last_harvest ? {:from => harvest.last_harvest.utc} : {}
#    records = harvest.dspace_client.list_records(params)
#    assert_not_equal records.count, 0
#  end
#end