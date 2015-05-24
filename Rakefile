require "./app/app"
require "sinatra/activerecord/rake"

task default: %w[test]

task :test do
  ruby "test/test.rb"
end

namespace :db do
  task :load_config do
    require "./app"
  end
end