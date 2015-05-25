require "./app/app"
require "sinatra/activerecord/rake"
require "rack/test"
require 'rake/testtask'
require 'rspec/core/rake_task'
 
RSpec::Core::RakeTask.new :specs do |task|
  task.pattern = Dir['spec/**/*_spec.rb']
end
 
task :default => ['specs']

namespace :db do
  task :load_config do
    require "./app"
  end
end