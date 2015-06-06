ENV['RACK_ENV'] ||= 'development'
 
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require 'rubygems'
require 'bundler'
require 'dotenv'
require 'sinatra/base'
require 'sinatra/activerecord'
Dotenv.load

require_relative 'models/airing'
require_relative 'models/dj'
require_relative 'models/episode'
require_relative 'models/show'
require_relative 'models/song'

require_relative 'api_airing'
require_relative 'api_dj'
require_relative 'api_episode'
require_relative 'api_show'


module Teal
  class App < Sinatra::Base
  	register Sinatra::ActiveRecordExtension

  	# root route responds with a cool string
    get '/' do
    	content_type :json
    	"teal is the best color ever".to_json
    end 
  end
end