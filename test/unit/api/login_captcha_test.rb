require File.dirname(__FILE__) + '/test_helper'

class LoginCaptchaTest < ActiveSupport::TestCase

  url = "/api/v1/login-captcha?"

  def setup()
	environment = Environment.default
    environment.api_captcha_settings = {
        enabled: true,
        provider: 'serpro',
        serpro_client_id:  '0000000000000000',
        verify_uri:  'http://captcha.serpro.gov.br/validate',
    }
    environment.save!
  	
  end

  should 'not generate private token when login without captcha' do
    params = {}
    post "#{url}#{params.to_query}"
    json = JSON.parse(last_response.body)
    puts "JSon1: #{json}"
    assert json["private_token"].blank?
  end

  should 'generate private token when login with captcha' do
  	#request = mock()
	stub_request(:post, "http://captcha.serpro.gov.br/validate").
  		with(:body => "0000000000000000&4324343&4030320",
       		:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
  				to_return(:status => 200, :body => "1", :headers => {})
  	
    # Mock the user to check the private_token
    token = "private_token@1234"
    user = mock
    User.expects(:new).returns(user)
    user.expects(:generate_private_token!).returns(token)
    # To store the user session helpers.rb call the private_token method
    user.expects(:private_token).times(2).returns(token)

    params = {:txtToken_captcha_serpro_gov_br => '4324343', :captcha_text => '4030320'}  	
    post "#{url}#{params.to_query}"
    json = JSON.parse(last_response.body)
    puts "JSon2: #{json}"
    assert !json["private_token"].blank?
    ret = json["private_token"]
    assert ret == token
  end

end