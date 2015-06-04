# set environment to test
ENV['RACK_ENV'] = 'test'

require 'factory_girl'
require 'database_cleaner'
require 'multi_json'


# require the app itself
require_relative File.join('..', 'app/app')

# require the factorygirl config
require 'factories'
 
RSpec.configure do |config|
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
  	end
  end

 
  def app
    Teal::App
  end

end