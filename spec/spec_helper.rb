# set environment to test
ENV['RACK_ENV'] = 'test'

require 'database_cleaner'

# require the app itself
require_relative File.join('..', 'app/app')

# configure rspec
RSpec.configure do |config|
  include Rack::Test::Methods

     config.before(:suite) do
          DatabaseCleaner.clean_with(:truncation)
     end

     config.before(:each) do
          DatabaseCleaner.start
          DatabaseCleaner.strategy = :transaction
     end

     config.after(:each) do
          DatabaseCleaner.clean
     end

  config.color = true

  def app
    Teal::App
  end

end
