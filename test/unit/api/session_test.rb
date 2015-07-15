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
    params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com" }
    post "/api/v1/register?#{params.to_query}"
    assert_equal 201, last_response.status
  end

  should 'do not register a user without email' do
    params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => nil }
    post "/api/v1/register?#{params.to_query}"
    assert_equal 400, last_response.status
  end

  should 'do not register a duplicated user' do
    params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com" }
    post "/api/v1/register?#{params.to_query}"
    post "/api/v1/register?#{params.to_query}"
    assert_equal 400, last_response.status
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


end
