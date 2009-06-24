require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__) + '/../lib/rack/metrics'

configure do
  TRACKING_FILE = "tracking.db"
  use Rack::Metrics::Tracking, Rack::Metrics::Storage::Marshal.new(TRACKING_FILE)
end


get '/' do
  "Root"
end

get '/subpage' do
  "Sub page"
end