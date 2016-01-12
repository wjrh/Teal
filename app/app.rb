require 'rubygems'
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym
require 'mongo_mapper'

# load up the config
# this reads our configuration file
# which has necessary variables to run this program
# these variables are accessed through Teal.config hash
require_relative 'config'

# require models
require_relative 'models/program'
require_relative 'models/episode'
require_relative 'models/media'

#require other files for the class
require_relative 'api_program'
require_relative 'api_episode'
require_relative 'api_login'
require_relative 'xml_feed'

module Teal
  class App < Sinatra::Base

    configure do
			#configure our MongoDB connection
			dbconn = Mongo::Connection.new(
		  Teal.config.mongo_url,
		  Teal.config.mongo_port)
			
			#mongomapper configuration
      MongoMapper.connection = dbconn
      MongoMapper.database = "teal_db"
			
			# build an index on the shortnames of programs
			# this allows faster access on shortnames of programs
      Program.ensure_index(:shortname)
    end

		# enable sessions by placing cookie 
		use Rack::Session::Cookie, 	:key => 'teal.session',
			                         	:domain => Teal.config.domain,
																:path => '/',
																:expire_after => 2592000,
																:secret => Teal.config.cookie_secret,
																#uncomment this when running over https
																#:secure => true
																:old_secret => Teal.config.old_cookie_secret,
																:http_only => true,
																:sidbits => 256


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
