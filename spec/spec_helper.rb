# set environment to test
ENV['RACK_ENV'] = 'test'

require 'factory_girl'
require 'database_cleaner'
require 'multi_json'


# require the app itself
require_relative File.join('..', 'app/app')

# require the factorygirl factories
require 'factories'
 
RSpec.configure do |config|
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  config.before(:suite) do

    DatabaseCleaner.clean_with :truncation  # clean DB of any leftover data
    DatabaseCleaner.strategy = :transaction # rollback transactions between each test
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.color = true

  def app
    Teal::App
  end

end

# Request helpers

# def get_json(path)
#   get path
#   json_parse(last_response.body)
# end

# def post_json(url, data)
#   post(url, MultiJson.dump(hash, pretty: true), { "CONTENT_TYPE" => "application/json" })
#   json_parse(last_response.body)
# end

# # JSON helpers

# def json_parse(body)
#   MultiJson.load(body, symbolize_keys: true)
# end

# def json(hash)
#   MultiJson.dump(hash, pretty: true)
# end
