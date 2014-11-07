require File.dirname(__FILE__) + '/../test_helper'

class DspaceHarvestTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
  end

  attr_reader :environment

  should 'create delayed job when start' do
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment)
    assert !harvest.find_job.present?
    harvest.start
    assert harvest.find_job.present?
  end

  should 'not duplicate harvest job' do
    harvest = VirtuosoPlugin::DspaceHarvest.new(environment)
    assert_difference "harvest.find_job.count", 1 do
      5.times { harvest.start }
    end
  end

end
