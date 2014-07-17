# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# rails tasks
require 'tasks/rails'

# plugins' tasks
plugins_tasks = Dir.glob("config/plugins/*/{tasks,lib/tasks,rails/tasks}/**/*.rake").sort +
  Dir.glob("config/plugins/*/vendor/plugins/*/{tasks,lib/tasks,rails/tasks}/**/*.rake").sort
plugins_tasks.each{ |ext| load ext }


desc "Print out grape routes"
task :grape_routes => :environment do
  #require 'api/api.rb'
  API::API.routes.each do |route|
    puts route
    method = route.route_method
    path = route.route_path
    puts "     #{method} #{path}"
  end
end
