require 'test/unit/assertions'
World(Test::Unit::Assertions)

require 'rack/test'

$:.unshift(File.dirname(__FILE__) + "/../../vendor/webrat/lib")
require 'webrat'
Webrat.configure do |config|
  config.mode = :rack_test
end

require File.dirname(__FILE__) + '/../../example/example.rb'

World do
  def app
    @app = Rack::Builder.new do
      run Sinatra::Application
    end
  end
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
end