require 'sinatra'

module Rack
  module Metrics
    class Goals < Sinatra::Base
      set :root, ::File.dirname(__FILE__) + "/goals"

      get "/_metrics/goals" do
        erb :listing
      end
      
      get "/_metrics/goals/new" do
        erb :new
      end
      
      def storage=(storage)
        @storage = storage
      end
    end
  end
end