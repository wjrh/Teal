require 'rubygems'
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require 'mongo_mapper'

# load up the config
require_relative 'config'

# require models
require_relative 'models/program'
require_relative 'models/episode'
require_relative 'models/media'

#require other files for the class
require_relative 'api_program'
require_relative 'api_episode'

module Teal
  class App < Sinatra::Base

    configure do
      MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
      MongoMapper.database = "teal_db"
      Program.ensure_index(:shortname)
    end

    # make everything be a json response (callback to every route)
    before do
      content_type 'application/json'

      headers 'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'DELETE']
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

    options "*" do
      response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"

      # Needed for AngularJS
      response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

      halt 200
    end


  end
end
