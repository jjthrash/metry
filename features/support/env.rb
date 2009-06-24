require 'rack/test'
require 'test/unit/assertions'

World(Test::Unit::Assertions)


require File.dirname(__FILE__) + '/../../example/example.rb'

World do
  def app
    @app = Rack::Builder.new do
      run Sinatra::Application
    end
  end
  include Rack::Test::Methods
end