require 'rubygems'
require 'sinatra'

$: << File.dirname(__FILE__) + '/../lib'
require 'rack/metrics/tracking'
require 'rack/metrics/storage/tokyo'
#require 'rack/metrics/storage/memory'

configure do
  TRACKING_STORAGE = Rack::Metrics::Storage::Tokyo.new("tracking")
  #TRACKING_STORAGE = Rack::Metrics::Storage::Memory.new
  use Rack::Metrics::Tracking, TRACKING_STORAGE
end

get '/' do
  "Root"
end

get '/subpage' do
  "Sub page"
end

get '/extra' do
  request.env[Rack::Metrics::Tracking::EXTRA]["extra"] = params[:track]
end