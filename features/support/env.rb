require 'test/unit/assertions'
World(Test::Unit::Assertions)

require 'rack/test'

$: << File.dirname(__FILE__) + "/../../vendor/webrat/lib"
require 'webrat'
require 'logger'
Webrat.configure do |config|
  config.mode = :rack_test
end

World(Rack::Test::Methods)
World(Webrat::Methods)
World(Webrat::Matchers)

require File.dirname(__FILE__) + '/../../example/example.rb'
def app
  Rack::Builder.new do
    run Sinatra::Application
  end
end