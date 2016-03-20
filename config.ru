require File.expand_path(File.dirname(__FILE__) + '/teal/app')
require 'rack/throttle'

#max 120 requests per minute
use Rack::Throttle::Minute, :max => 180 

run Teal::App