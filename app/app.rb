require 'rubygems'
require 'bundler'
require 'dotenv'
require 'sinatra/activerecord'

$:.unshift File.dirname(__FILE__)
require 'models/airing'
require 'models/dj'
require 'models/episode'
require 'models/show'
require 'models/song'

Dotenv.load
Bundler.require

module Teal
  class App < Sinatra::Base
  	register Sinatra::ActiveRecordExtension
  	set :database_file, "db/database.yml"

  	# get root route
    get '/' do
      "this is teal speaking"
    end 

    # route to get all djs
    get '/djs' do
    	content_type :json
    	Dj.select(:id, :dj_name).all.to_json
    end
  end
end