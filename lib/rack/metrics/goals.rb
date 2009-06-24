require 'sinatra'

module Rack
  module Metrics
    class Goals < Sinatra::Base
      set :root, ::File.dirname(__FILE__) + "/goals"

      get "/_metrics/goals" do
        erb :listing
      end
    end
  end
end