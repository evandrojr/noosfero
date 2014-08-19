require File.dirname(__FILE__) + '/../test_helper'


class NotificationPluginAdminControllerTest < ActionController::TestCase


  def setup
    @controller = NotificationPluginAdminController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @environment = fast_create(Environment)
   
    login_as(create_admin_user(@environment))
  end

  should 'get a first prompt' do
    get :index
    assert_response :success
  end

end
