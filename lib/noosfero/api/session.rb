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
      #   POST /register?email=some@mail.com&password=pas&password_confirmation=pas&login=some
      params do
        requires :email, type: String, desc: _("Email")
        requires :login, type: String, desc: _("Login")
        requires :password, type: String, desc: _("Password")
        requires :password_confirmation, type: String, desc: _("Password confirmation")
      end
      post "/register" do
        attrs = attributes_for_keys [:email, :login, :password, :password_confirmation] + environment.signup_person_fields
        remote_ip = (request.respond_to?(:remote_ip) && request.remote_ip) || (env && env['REMOTE_ADDR'])

        unless test_captcha(remote_ip, params, environment) == true
          render_api_error!(_('Please solve the test in order to register.'), 401)
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
