ENV['RACK_ENV'] = 'test'
 
require_relative File.join('..', 'app/app')
 
RSpec.configure do |config|
  include Rack::Test::Methods
 
  def app
    Teal::App
  end
end