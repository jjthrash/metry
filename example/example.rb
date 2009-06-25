require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__) + '/../lib/rack/metrics/tracking'
require File.dirname(__FILE__) + '/../lib/rack/metrics/storage'
require File.dirname(__FILE__) + '/../lib/rack/metrics/goals'

configure do
  TRACKING_FILE = "tracking.db"
  metrics_storage = Rack::Metrics::Storage::Marshal.new(TRACKING_FILE)
  use Rack::Metrics::Tracking, metrics_storage
  use Rack::Metrics::Goals do |app|
    app.storage = metrics_storage
  end
end

get '/' do
  "Root"
end

get '/subpage' do
  "Sub page"
end