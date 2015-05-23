ENV['RACK_ENV'] = 'test'

require File.expand_path("../../app/app", __FILE__)
require "rack/test"

class TealTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Teal::App
  end

  def test_it_says_hello
    get '/'
    assert last_response.ok?
    assert_equal 'this is teal speaking', last_response.body
  end

end
