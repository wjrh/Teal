require 'rubygems'
require 'bundler'
Bundler.require
require 'redis'
require 'mongoid'
require 'resque'
require 'fileutils'
require 'logger'
require 'protected_attributes'

require_relative 'bson'

# load up the config
# this reads our configuration file
# which has necessary variables to run this program
# these variables are accessed through Teal.config hash
require_relative 'config'

# require models
require_relative 'models/program'
require_relative 'models/episode'
require_relative 'models/identity'
require_relative 'models/track'

# require models
require_relative 'upload/encode'
require_relative 'upload/flow_controller'

#require other files for the class
require_relative 'api_program'
require_relative 'api_episode'
require_relative 'api_login'
require_relative 'xml_feed'
require_relative 'api_upload'
require_relative 'api_download'
require_relative 'api_track'

module Teal
  class App < Sinatra::Base

    configure do
			Mongoid.load!("config/mongoid.yml")	
			$redis = Redis.new(:url => Teal.config.redis_url)
			Resque.redis = $redis
    end

    # make everything be a json response (callback to every route)
    before do
      content_type 'application/json'

      headers 'Access-Control-Allow-Origin' => "#{Teal.config.front_end_subdomain}",
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'DELETE'],
						'Access-Control-Allow-Credentials' => true,
            'teal-logged-in-as' => current_user
    end

  	# root route responds with a cool string
		get '/' do
    	content_type :json
    	info = {
    		"about" => "Teal is WJRH's DJ-Program-Episode management API",
    		"documentation" => "github.com/wjrh/Teal",
    		"contact" => "renandincer+teal@gmail.com",
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