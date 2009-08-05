require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__) + '/../lib/metry'

configure do
  Metry.init("tracking")
  use Metry::Rack::Tracking
  use Metry::Psycho, {:path => "/admin/metry"}
end

get '/' do
  "Root"
end

get '/subpage' do
  "Sub page"
end

get '/extra' do
  request.env["metry.event"]["extra"] = params[:track]
end