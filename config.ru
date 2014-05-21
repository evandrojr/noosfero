# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

rails_app = Rack::Builder.new do
  run Noosfero::Application
end

run Rack::Cascade.new([
  API::API,
  rails_app
])
