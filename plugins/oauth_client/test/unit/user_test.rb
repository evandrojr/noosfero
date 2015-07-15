require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @provider = OauthClientPlugin::Provider.create!(:name => 'name', :strategy => 'strategy')
  end
  attr_reader :provider

  should 'password is not required if there is a oauth provider' do
    User.create!(:email => 'testoauth@example.com', :login => 'testoauth', :oauth_providers => [provider])
  end

  should 'password is required if there is a oauth provider' do
    user = User.new(:email => 'testoauth@example.com', :login => 'testoauth')
    user.save
    assert user.errors[:password].present?
  end

  should 'activate user when created with oauth' do
    user = User.create!(:email => 'testoauth@example.com', :login => 'testoauth', :oauth_providers => [provider])
    assert user.activated?
  end

  should 'not activate user when created without oauth' do
    user = fast_create(User)
    assert !user.activated?
  end

  should 'not make activation code when created with oauth' do
    user = User.create!(:email => 'testoauth@example.com', :login => 'testoauth', :oauth_providers => [provider])
    assert !user.activation_code
  end

  should 'make activation code when created without oauth' do
    user = User.create!(:email => 'testoauth@example.com', :login => 'testoauth', :password => 'test', :password_confirmation => 'test')
    assert user.activation_code
  end

  should 'not send activation email when created with oauth' do
    UserMailer.expects(:activation_code).never
    user = User.create!(:email => 'testoauth@example.com', :login => 'testoauth', :oauth_providers => [provider])
  end

  should 'save oauth data when create with oauth' do
    OauthClientPlugin::SignupDataStore.stubs(:get_oauth_data).returns({
      :provider_id => provider.id,
      :credentials => {
        token: 'abcdef',
        any_field: 'abx'
      }
    })
    user = User.create!(:email => 'testoauth@example.com', :login => 'testoauth', :oauth_providers => [], :oauth_signup_token => 'token')
    user.oauth_signup_token = 'token'
    assert user.oauth_user_providers.first.oauth_data.present?
  end

  should 'save oauth  as a hash when creating user with oauth' do
    OauthClientPlugin::SignupDataStore.stubs(:get_oauth_data)
    .returns(
        {
          :provider_id => provider.id,
          :credentials => {
            token: 'abcdef',
            any_field: 'abx'
          }
        }
      )
    user = User.create!(:email => 'testoauth@example.com', :login => 'testoauth', :oauth_providers => [], :oauth_signup_token => 'token')
    assert user.oauth_user_providers.first.oauth_data.is_a? Hash
  end

  should 'note save oauth user provider when user is not originated from oauth' do
    user = User.create!(:email => 'testoauth@example.com', :login => 'testoauth', :password => 'test', :password_confirmation => 'test')
    assert user.oauth_user_providers.count.eql? 0
  end

end
