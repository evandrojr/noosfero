require File.dirname(__FILE__) + '/test_helper'

class SessionTest < ActiveSupport::TestCase

  def setup
    login_api
  end

  should 'generate private token when login' do
    params = {:login => "testapi", :password => "testapi"}
    post "/api/v1/login?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert !json["private_token"].blank?
  end

  should 'return 401 when login fails' do
    user.destroy
    params = {:login => "testapi", :password => "testapi"}
    post "/api/v1/login?#{params.to_query}"
    assert_equal 401, last_response.status
  end

  should 'register a user' do
    Environment.default.enable('skip_new_user_email_confirmation')
    params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com" }
    post "/api/v1/register?#{params.to_query}"
    assert_equal 201, last_response.status
    json = JSON.parse(last_response.body)
    assert json['activated']
    assert json['private_token'].present?
  end

  should 'register an inactive user' do
    params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com" }
    post "/api/v1/register?#{params.to_query}"
    assert_equal 201, last_response.status
    json = JSON.parse(last_response.body)
    assert !json['activated']
    assert json['private_token'].blank?
  end

  should 'do not register a user without email' do
    params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => nil }
    post "/api/v1/register?#{params.to_query}"
    assert_equal 400, last_response.status
  end

  should 'not register a duplicated user' do
    params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com" }
    post "/api/v1/register?#{params.to_query}"
    post "/api/v1/register?#{params.to_query}"
    assert_equal 400, last_response.status
    json = JSON.parse(last_response.body)
  end

  should 'detected error, Name or service not known, for Serpro Captcha communication' do
    environment = Environment.default
    environment.api_captcha_settings = {
        enabled: true,
        provider: 'serpro',
        serpro_client_id:  '0000000000000000',
        verify_uri:  'http://someserverthatdoesnotexist.mycompanythatdoesnotexist.com/validate',
    }
    environment.save!
    params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com",
              :txtToken_captcha_serpro_gov_br => '4324343', :captcha_text => '4030320'}
    post "/api/v1/register?#{params.to_query}"
    assert_equal "Serpro captcha error: getaddrinfo: Name or service not known", JSON.parse(last_response.body)["message"]
  end

  # TODO: Add another test cases to check register situations
  should 'activate a user' do
    params = {
      :login => "newuserapi",
      :password => "newuserapi",
      :password_confirmation => "newuserapi",
      :email => "newuserapi@email.com"
    }
    user = User.new(params)
    user.save!

    params = { activation_code: user.activation_code}
    patch "/api/v1/activate?#{params.to_query}"
    assert_equal 200, last_response.status
  end

  should 'do not activate a user if admin must approve him' do
    params = {
      :login => "newuserapi",
      :password => "newuserapi",
      :password_confirmation => "newuserapi",
      :email => "newuserapi@email.com",
      :environment => Environment.default
    }
    user = User.new(params)
    user.environment.enable('admin_must_approve_new_users')
    user.save!

    params = { activation_code: user.activation_code}
    patch "/api/v1/activate?#{params.to_query}"
    assert_equal 202, last_response.status
    assert_equal 'Waiting for admin moderate user registration', JSON.parse(last_response.body)["message"]
  end

  should 'do not activate a user if the token is invalid' do
    params = {
      :login => "newuserapi",
      :password => "newuserapi",
      :password_confirmation => "newuserapi",
      :email => "newuserapi@email.com",
      :environment => Environment.default
    }
    user = User.new(params)
    user.save!

    params = { activation_code: '70250abe20cc6a67ef9399cf3286cb998b96aeaf'}
    patch "/api/v1/activate?#{params.to_query}"
    assert_equal 412, last_response.status
  end

end
