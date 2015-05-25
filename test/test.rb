ENV['RACK_ENV'] = 'test'

require File.expand_path("../../app/app", __FILE__)
require "rack/test"


class TealTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Teal::App
  end



  def test_listing_djs
  	get '/djs'
  	assert last_response.ok?
  end

  def test_listing_episoes
  	get '/episodes'
  	assert last_response.ok?
  end

  def test_listing_shows
  	get '/shows'
  	assert last_response.ok?
  end


end
