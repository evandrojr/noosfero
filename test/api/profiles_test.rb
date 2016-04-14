require_relative 'test_helper'

class ProfilesTest < ActiveSupport::TestCase

  def setup
    Profile.delete_all
  end

  should 'logged user list all profiles' do
    login_api
    person1 = fast_create(Person)
    person2 = fast_create(Person)
    community = fast_create(Community)
    get "/api/v1/profiles?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equivalent [person.id, person1.id, person2.id, community.id], json.map {|p| p['id']}
  end

  should 'logged user get person from profile id' do
    login_api
    some_person = fast_create(Person)
    get "/api/v1/profiles/#{some_person.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal some_person.id, json['id']
  end

  should 'logged user get community from profile id' do
    login_api
    community = fast_create(Community)
    get "/api/v1/profiles/#{community.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['id']
  end

  should 'anonymous list all profiles' do
    person1 = fast_create(Person)
    person2 = fast_create(Person)
    community = fast_create(Community)
    get "/api/v1/profiles"
    json = JSON.parse(last_response.body)
    assert_equivalent [person1.id, person2.id, community.id], json.map {|p| p['id']}
  end

  should 'anonymous get person from profile id' do
    some_person = fast_create(Person)
    get "/api/v1/profiles/#{some_person.id}"
    json = JSON.parse(last_response.body)
    assert_equal some_person.id, json['id']
  end

  should 'anonymous get community from profile id' do
    community = fast_create(Community)
    get "/api/v1/profiles/#{community.id}"
    json = JSON.parse(last_response.body)
    assert_equal community.id, json['id']
  end

  should 'display public custom fields to anonymous' do
    anonymous_setup
    CustomField.create!(:name => "Rating", :format => "string", :customized_type => "Profile", :active => true, :environment => Environment.default)
    some_profile = fast_create(Profile)
    some_profile.custom_values = { "Rating" => { "value" => "Five stars", "public" => "true"} }
    some_profile.save!

    get "/api/v1/profiles/#{some_profile.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert json['additional_data'].has_key?('Rating')
    assert_equal "Five stars", json['additional_data']['Rating']
  end

  should 'not display private custom fields to anonymous' do
    anonymous_setup
    CustomField.create!(:name => "Rating", :format => "string", :customized_type => "Profile", :active => true, :environment => Environment.default)
    some_profile = fast_create(Profile)
    some_profile.custom_values = { "Rating" => { "value" => "Five stars", "public" => "false"} }
    some_profile.save!

    get "/api/v1/profiles/#{some_profile.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    refute json.has_key?('Rating')
  end

end
