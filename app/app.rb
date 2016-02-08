require 'rubygems'
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym
require 'redis'
require 'mongoid'
require 'resque'

# load up the config
# this reads our configuration file
# which has necessary variables to run this program
# these variables are accessed through Teal.config hash
require_relative 'config'

# require models
require_relative 'models/program'
require_relative 'models/episode'

#require other files for the class
require_relative 'api_program'
require_relative 'api_episode'
require_relative 'api_login'
require_relative 'xml_feed'
require_relative 'encode'
require_relative 'api_upload'
require_relative 'api_download'

module Teal
  class App < Sinatra::Base

    configure do
			#configure our MongoDB connection

			Mongoid.load!("config/mongoid.yml")	
			
			$redis = Redis.new(:url => Teal.config.redis_url)
			Resque.redis = $redis

			# enable sessions by placing cookie 
			use Rack::Session::Cookie,:key => 'teal.session',
			                         	:domain => Teal.config.domain,
																:path => '/',
																:expire_after => 2592000,
																:secret => Teal.config.cookie_secret,
																#uncomment this when running over https
																#:secure => true
																:old_secret => Teal.config.old_cookie_secret,
																:http_only => true,
																:sidbits => 256
    end

	
    # make everything be a json response (callback to every route)
    before do
      content_type 'application/json'

      headers 'Access-Control-Allow-Origin' => "http://#{Teal.config.front_end_subdomain}",
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'DELETE'],
						'Access-Control-Allow-Credentials' => true
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
