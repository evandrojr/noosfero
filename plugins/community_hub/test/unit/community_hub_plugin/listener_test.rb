require File.dirname(__FILE__) + '/../../test_helper'

class ListenerTest < ActiveSupport::TestCase

  should 'initialize logger' do
    logger = CommunityHubPlugin::Listener.initialize_logger
    logfile = logger.instance_variable_get(:@logdev).instance_variable_get(:@filename)
    assert_instance_of(Logger, logger)
    assert File.exists?(logfile)
  end

  should 'log message' do
    logdir = File.join(RAILS_ROOT, 'log', CommunityHubPlugin::Listener.name.underscore)

    if File.exists?(logdir)
      Dir.foreach(logdir) { |f|
        fn = File.join(logdir, f);
        File.delete(fn) if f != '.' && f != '..'
      }
    end

    logger = CommunityHubPlugin::Listener.initialize_logger
    CommunityHubPlugin::Listener.log('testmessage')

    logfile = logger.instance_variable_get(:@logdev).instance_variable_get(:@filename)
    text = File.open(logfile).read

    assert_match /testmessage/, text
  end

end
