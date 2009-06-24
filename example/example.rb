require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__) + '/../lib/rack/metrics'

configure do
  TRACKING_FILE = "tracking.db"
  use Rack::Metrics::Tracking, TRACKING_FILE
end


get '/' do
  "Root"
end

post '/post' do
  "My name is #{params[:name]}"
end