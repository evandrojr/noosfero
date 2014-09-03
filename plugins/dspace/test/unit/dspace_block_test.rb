require File.dirname(__FILE__) + '/../test_helper'

require 'comment_controller'
# Re-raise errors caught by the controller.
class CommentController; def rescue_action(e) raise e end; end

class DspaceBlockTest < ActiveSupport::TestCase

  include AuthenticatedTestHelper
  fixtures :users, :environments

  def setup
    @controller = CommentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @profile = create_user('testinguser').person
    @environment = @profile.environment
  end
  attr_reader :profile, :environment

  should 'have a default title' do
    dspace_block = DspacePlugin::DspaceBlock.new
    block = Block.new
    assert_not_equal block.default_title, dspace_block.default_title
  end

  should 'have a help tooltip' do
    dspace_block = DspacePlugin::DspaceBlock.new
    block = Block.new
    assert_not_equal "", dspace_block.help
  end

  should 'describe itself' do
    assert_not_equal Block.description, DspacePlugin::DspaceBlock.description
  end

  should 'is editable' do
    block = DspacePlugin::DspaceBlock.new
    assert block.editable?
  end

  should 'expire' do
    assert_equal DspacePlugin::DspaceBlock.expire_on, {:environment=>[:article], :profile=>[:article]}
  end

end
