require File.dirname(__FILE__) + '/../../test_helper'

class MediationTest < ActiveSupport::TestCase

  def setup
    @env = fast_create(Environment)
    @user = create_user('testuser', :environment => @env).person
    @comm = fast_create(Community, :environment_id => @env.id)
    @hub = create_hub('hub', @comm, @user)
    @mediation = create_mediation(@hub, @comm)
  end

  should 'has setting profile_picture' do
    assert_respond_to @mediation, :profile_picture
  end

  should 'default value of setting profile_picture is blank' do
    assert_equal @mediation.profile_picture, ""
  end

  should 'generate timestamp for mediation' do
    assert CommunityHubPlugin::Mediation.timestamp
  end

  should 'default value of advertise is false' do
    assert !@mediation.advertise
  end

  should 'default value of notify comments is false' do
    assert !@mediation.notify_comments
  end

end
