require_relative 'test_helper'

class CommunitiesTest < ActiveSupport::TestCase

  def setup
    Community.delete_all
  end

  should 'list only communities' do
    login_api
    community = fast_create(Community, :environment_id => environment.id)
    enterprise = fast_create(Enterprise, :environment_id => environment.id) # should not list this enterprise
    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_not_includes json['communities'].map {|c| c['id']}, enterprise.id
    assert_includes json['communities'].map {|c| c['id']}, community.id
  end

  should 'list all communities' do
    login_api
    community1 = fast_create(Community, :environment_id => environment.id, :public_profile => true)
    community2 = fast_create(Community, :environment_id => environment.id)
    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [community1.id, community2.id], json['communities'].map {|c| c['id']}
  end

  should 'not list invisible communities' do
    login_api
    community1 = fast_create(Community, :environment_id => environment.id)
    fast_create(Community, :environment_id => environment.id, :visible => false)

    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal [community1.id], json['communities'].map {|c| c['id']}
  end

  should 'list private communities' do
      login_api
      community1 = fast_create(Community, :environment_id => environment.id)
      community2 = fast_create(Community, :environment_id => environment.id, :public_profile => false)

      get "/api/v1/communities?#{params.to_query}"
      json = JSON.parse(last_response.body)
      assert_equal [community1.id, community2.id], json['communities'].map {|c| c['id']}
  end

  should 'list private community for members' do
    login_api
    c1 = fast_create(Community, :environment_id => environment.id)
    c2 = fast_create(Community, :environment_id => environment.id, :public_profile => false)
    c2.add_member(person)

    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [c1.id, c2.id], json['communities'].map {|c| c['id']}
  end

  should 'create a community' do
    login_api
    params[:community] = {:name => 'some'}
    post "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 'some', json['community']['name']
  end

  should 'return 400 status for invalid community creation' do
    login_api
    post "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 400, last_response.status
  end

  should 'get community' do
    login_api
    community = fast_create(Community, :environment_id => environment.id)

    get "/api/v1/communities/#{community.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['community']['id']
  end

  should 'not get invisible community' do
    login_api
    community = fast_create(Community, :environment_id => environment.id, :visible => false)

    get "/api/v1/communities/#{community.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert json['community'].blank?
  end

  should 'not get private communities without permission' do
    login_api
    community = fast_create(Community, :environment_id => environment.id)
    fast_create(Community, :environment_id => environment.id, :public_profile => false)

    get "/api/v1/communities/#{community.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['community']['id']
  end

  should 'get private community for members' do
    login_api
    community = fast_create(Community, :environment_id => environment.id, :public_profile => false, :visible => true)
    community.add_member(person)

    get "/api/v1/communities/#{community.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['community']['id']
  end

  should 'list person communities' do
    login_api
    community = fast_create(Community, :environment_id => environment.id)
    fast_create(Community, :environment_id => environment.id)
    community.add_member(person)

    get "/api/v1/people/#{person.id}/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [community.id], json['communities'].map {|c| c['id']}
  end

  should 'not list person communities invisible' do
    login_api
    c1 = fast_create(Community, :environment_id => environment.id)
    c2 = fast_create(Community, :environment_id => environment.id, :visible => false)
    c1.add_member(person)
    c2.add_member(person)

    get "/api/v1/people/#{person.id}/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [c1.id], json['communities'].map {|c| c['id']}
  end

  should 'list communities with pagination' do
    login_api
    community1 = fast_create(Community, :public_profile => true, :created_at => 1.day.ago)
    community2 = fast_create(Community, :created_at => 2.days.ago)

    params[:page] = 2
    params[:per_page] = 1
    get "/api/v1/communities?#{params.to_query}"
    json_page_two = JSON.parse(last_response.body)

    params[:page] = 1
    params[:per_page] = 1
    get "/api/v1/communities?#{params.to_query}"
    json_page_one = JSON.parse(last_response.body)


    assert_includes json_page_one["communities"].map { |a| a["id"] }, community1.id
    assert_not_includes json_page_one["communities"].map { |a| a["id"] }, community2.id

    assert_includes json_page_two["communities"].map { |a| a["id"] }, community2.id
    assert_not_includes json_page_two["communities"].map { |a| a["id"] }, community1.id
  end

  should 'list communities with timestamp' do
    login_api
    community1 = fast_create(Community, :public_profile => true)
    community2 = fast_create(Community)

    community1.updated_at = Time.now + 3.hours
    community1.save!

    params[:timestamp] = Time.now + 1.hours
    get "/api/v1/communities/?#{params.to_query}"
    json = JSON.parse(last_response.body)

    assert_includes json["communities"].map { |a| a["id"] }, community1.id
    assert_not_includes json["communities"].map { |a| a["id"] }, community2.id
  end

  should 'anonymous list only communities' do
    anonymous_setup
    community = fast_create(Community, :environment_id => environment.id)
    enterprise = fast_create(Enterprise, :environment_id => environment.id) # should not list this enterprise
    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_not_includes json['communities'].map {|c| c['id']}, enterprise.id
    assert_includes json['communities'].map {|c| c['id']}, community.id
  end

  should 'anonymous list all communities' do
    anonymous_setup
    community1 = fast_create(Community, :environment_id => environment.id, :public_profile => true)
    community2 = fast_create(Community, :environment_id => environment.id)
    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [community1.id, community2.id], json['communities'].map {|c| c['id']}
  end

  should 'not anonymous list invisible communities' do
    anonymous_setup
    community1 = fast_create(Community, :environment_id => environment.id)
    fast_create(Community, :environment_id => environment.id, :visible => false)

    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal [community1.id], json['communities'].map {|c| c['id']}
  end

  should 'anonymous list private communities' do
    anonymous_setup
    community1 = fast_create(Community, :environment_id => environment.id)
    community2 = fast_create(Community, :environment_id => environment.id, :public_profile => false)

    get "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal [community1.id, community2.id], json['communities'].map {|c| c['id']}
  end



  should 'not anonymous create a community' do
    anonymous_setup
    params[:community] = {:name => 'some'}
    post "/api/v1/communities?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 401, last_response.status
  end

  should 'anonymous get community' do
    anonymous_setup
    community = fast_create(Community, :environment_id => environment.id)
    get "/api/v1/communities/#{community.id}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['community']['id']
  end

  should 'not anonymous get invisible community' do
    anonymous_setup
    community = fast_create(Community, :environment_id => environment.id, :visible => false)
    get "/api/v1/communities/#{community.id}"
    json = JSON.parse(last_response.body)
    assert json['community'].blank?
  end

  should 'anonymous not get private communities' do
    anonymous_setup
    community = fast_create(Community, :environment_id => environment.id)
    fast_create(Community, :environment_id => environment.id, :public_profile => false)
    get "/api/v1/communities/#{community.id}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['community']['id']
  end

  should 'anonymous list communities with pagination' do
    anonymous_setup
    community1 = fast_create(Community, :public_profile => true, :created_at => 1.day.ago)
    community2 = fast_create(Community, :created_at => 2.days.ago)

    params[:page] = 2
    params[:per_page] = 1
    get "/api/v1/communities?#{params.to_query}"
    json_page_two = JSON.parse(last_response.body)

    params[:page] = 1
    params[:per_page] = 1
    get "/api/v1/communities?#{params.to_query}"
    json_page_one = JSON.parse(last_response.body)

    assert_includes json_page_one["communities"].map { |a| a["id"] }, community1.id
    assert_not_includes json_page_one["communities"].map { |a| a["id"] }, community2.id

    assert_includes json_page_two["communities"].map { |a| a["id"] }, community2.id
    assert_not_includes json_page_two["communities"].map { |a| a["id"] }, community1.id
  end

  should 'anonymous list communities with timestamp' do
    anonymous_setup
    community1 = fast_create(Community, :public_profile => true)
    community2 = fast_create(Community)

    community1.updated_at = Time.now + 3.hours
    community1.save!

    params[:timestamp] = Time.now + 1.hours
    get "/api/v1/communities/?#{params.to_query}"
    json = JSON.parse(last_response.body)

    assert_includes json["communities"].map { |a| a["id"] }, community1.id
    assert_not_includes json["communities"].map { |a| a["id"] }, community2.id
  end

end
