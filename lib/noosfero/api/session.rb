require "uri"

module Noosfero
  module API

    class Session < Grape::API

      # Login to get token
      #
      # Parameters:
      #   login (*required) - user login or email
      #   password (required) - user password
      #
      # Example Request:
      #  POST http://localhost:3000/api/v1/login?login=adminuser&password=admin
      post "/login" do
        user ||= User.authenticate(params[:login], params[:password], environment)

        return unauthorized! unless user
        user.generate_private_token!
        @current_user = user
        present user, :with => Entities::UserLogin
      end

      # Create user.
      #
      # Parameters:
      #   email (required)                  - Email
      #   password (required)               - Password
      #   login                             - login
      # Example Request:
      #   POST /register?email=some@mail.com&password=pas&login=some
      params do
        requires :email, type: String, desc: _("Email")
        requires :login, type: String, desc: _("Login")
        requires :password, type: String, desc: _("Password")
      end
      post "/register" do
        unique_attributes! User, [:email, :login]
        attrs = attributes_for_keys [:email, :login, :password] + environment.signup_person_fields
        attrs[:password_confirmation] = attrs[:password]
        remote_ip = (request.respond_to?(:remote_ip) && request.remote_ip) || (env && env['REMOTE_ADDR'])
        private_key = API.NOOSFERO_CONF['api_recaptcha_private_key']
        api_recaptcha_verify_uri = API.NOOSFERO_CONF['api_recaptcha_v1_verify_uri']
        # TODO: FIX THAT
        # TEST WILL NOT STUB WITHOUT Noosfero::API::APIHelpers
        # Leave with the full namespace otherwise the stub for the test will fail
        begin
          # This will run from test
          captcha_result = Noosfero::API::APIHelpers.verify_recaptcha_v1(remote_ip, params['recaptcha_response_field'], private_key, params['recaptcha_challenge_field'], api_recaptcha_verify_uri)
        rescue NoMethodError
          # Normal execution
          captcha_result = verify_recaptcha_v1(remote_ip, params['recaptcha_response_field'], private_key, params['recaptcha_challenge_field'], api_recaptcha_verify_uri)
        end
        unless  captcha_result === true
          render_api_error!(_('Please solve the test in order to register.'), 400)
          return
        end
        user = User.new(attrs)
        if  user.save
          user.activate
          user.generate_private_token!
          present user, :with => Entities::UserLogin
        else
          message = user.errors.to_json
          render_api_error!(message, 400)
        end
      end
    end
  end
end
