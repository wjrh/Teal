require File.expand_path(File.dirname(__FILE__) + '/app/app')
require 'rack/throttle'

use Rack::Throttle::Minute, :max => 120 #max 120 requests per minute

run Teal::App