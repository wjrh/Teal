require 'rubygems'
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require 'mongo_mapper'

# require models
require_relative 'models/program'
require_relative 'api_program'

module Teal
  class App < Sinatra::Base

    configure do
      MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
      MongoMapper.database = "teal_db"
    end

    # make everything be a json response (callback to every route)
    before do
      content_type 'application/json'
    end

  	# root route responds with a cool string
    get '/' do
    	content_type :json
    	info = {
    		"about" => "Teal is WJRH's DJ-Program-Episode management API",
    		"documentation" => "github.com/wjrh/Teal",
    		"contact" => "wjrh@lafayette.edu",
    		"authors" => ["Renan Dincer"] #add your name here if you're contributing.
    	}
    	JSON.pretty_generate(info)
    end
  end
end
