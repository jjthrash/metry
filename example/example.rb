require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__) + '/../lib/metry'

configure do
  Metry.init Metry::Tokyo.new("tracking")
  #Metry.init Metry::Memory.new
  use Metry::Rack::Tracking
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