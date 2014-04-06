require "config/environment"


#use Rails::Rack::LogTailer
#use Rails::Rack::Static
#run ActionController::Dispatcher.new

rails_app = Rack::Builder.new do
  use Rails::Rack::LogTailer
  use Rails::Rack::Static
  run ActionController::Dispatcher.new
end
 
run Rack::Cascade.new([
  API::API,
  rails_app
])
