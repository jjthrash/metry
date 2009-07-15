require 'sinatra/base'

module Metry
  class Psycho < Sinatra::Base
    include Sinatra::Delegator
    
    def initialize(app, path)
      super(app)
      @path = path

      set :views, File.dirname(__FILE__) + '/psycho'

      get "#{@path}/?" do
        @visitors = Visitor.all
        erb :visitors
      end
      
      get "#{@path}/visitor/:id" do
        @visitor = Visitor.find(params["id"])
        erb :visitor
      end

      helpers do
        define_method(:link_to) do |text, url|
          %(<a href="#{path}#{url}">#{text}</a>)
        end
      end
    end
    
    class Visitor
      def self.all
        Metry.current.visitors.collect{|e| new(e)}
      end
      
      def self.find(id)
        new(Metry.current.visitor(id).merge(:pk => id))
      end

      def initialize(visitor)
        @visitor = visitor
      end
      
      def id
        @visitor[:pk]
      end
      
      def events
        Metry.current.events_for(id).collect{|e| Event.new(e)}
      end
    end
    
    class Event
      def initialize(event)
        @event = event
      end
      
      def path
        @event["path"]
      end
    end
  end
end