require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__) + '/../lib/metry'

configure do
  METRY = Metry::Tokyo.new("tracking")
  #METRY = Metry::Memory.new
  use Metry::Rack::Tracking, METRY
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