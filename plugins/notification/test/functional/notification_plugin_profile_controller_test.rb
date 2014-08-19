require File.dirname(__FILE__) + '/../test_helper'

class NotificationPluginProfileControllerTest < ActionController::TestCase

  def setup
    @environment = Environment.default
  
    @controller = NotificationPluginProfileController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  
    @user = create_user('john', :email => 'john@doe.org', :password => 'dhoe', :password_confirmation => 'dhoe')
    @profile = fast_create(Community, :environment_id => @environment.id)
    @role = Role.create(:name => 'somerole', :permissions => ['see_loby_notes'])
    @profile.affiliate(@user.person, role)

    login_as(@user.login)
  end

  attr_reader :profile, :role

  should 'access lobby_notes action' do
    get :lobby_notes, :profile => profile.identifier
    assert :lobby_notes
    assert_response :success
  end

  should 'list the lobby notes of profile' do
    note1 = fast_create(NotificationPlugin::LobbyNoteContent, :profile_id => profile.id, :start_date => Date.today)
    note2 = fast_create(NotificationPlugin::LobbyNoteContent, :profile_id => profile.id, :start_date => Date.today)
    get :lobby_notes, :profile => profile.identifier
    
    assert_equivalent [note1, note2], assigns(:events)
  end

  should 'not see lobby_notes if there is no see_loby_notes permission' do
    role.permissions = []
    role.save
    get :lobby_notes, :profile => profile.identifier
    assert_response :forbidden
  end

end
