require 'test_helper'

class VirtuosoPluginCustomQueriesControllerTest < ActionController::TestCase
  setup do
    @custom_query = VirtuosoPlugin::CustomQuery.create!(:name => 'name', :query => 'query', :template => 'template', :environment => Environment.default)
    login_as(create_admin_user(Environment.default))
  end

  should "get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_queries)
  end

  should "get new" do
    get :new
    assert_response :success
  end

  should "create custom_query" do
    assert_difference('VirtuosoPlugin::CustomQuery.count') do
      post :create, custom_query: { name: @custom_query.name, enabled: @custom_query.enabled, query: @custom_query.query, template: @custom_query.template }
    end

    assert_redirected_to :action => :index
  end

  should "get edit" do
    get :edit, id: @custom_query
    assert_response :success
  end

  should "update custom_query" do
    put :update, id: @custom_query, custom_query: { name: @custom_query.name, enabled: @custom_query.enabled, query: @custom_query.query, template: @custom_query.template }
    assert_redirected_to :action => :index
  end

  should "destroy custom_query" do
    assert_difference('VirtuosoPlugin::CustomQuery.count', -1) do
      delete :destroy, id: @custom_query
    end

    assert_redirected_to :action => :index
  end
end
