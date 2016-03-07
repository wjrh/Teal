require File.expand_path(File.dirname(__FILE__) + '/app/app')
require 'rack/throttle'

use Rack::Throttle::Interval
run Teal::App
