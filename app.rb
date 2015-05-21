require 'rubygems'
require 'bundler'
require 'dotenv'

Dotenv.load
Bundler.require

module Teal
  class App < Sinatra::Base
    get '/' do
      "Hello Renan!"
    end 
  end
end