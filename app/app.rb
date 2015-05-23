require 'rubygems'
require 'bundler'
require 'dotenv'
require 'sinatra/activerecord'

Dotenv.load
Bundler.require

module Teal
  class App < Sinatra::Base
    get '/' do
      "this is teal speaking"
    end 
  end
end