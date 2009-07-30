require 'sinatra/base'

module Metry
  class Psycho < Sinatra::Base
    def initialize(app, options={})
      super(app)
      @options = options
      path = options[:path] || "/psycho"
      auth = options[:authorize] || proc{true}
      on_deny = options[:on_deny] || proc{[403, {"Content-Type" => "text/plain"}, "You must log in."]}
      
      self.class.class_eval do
        set :views, File.dirname(__FILE__) + '/psycho'
        
        before do
          if unescape(@request.path_info) =~ /^#{path}/ && !auth.call(env)
            reply = on_deny.call(env)
            status reply.first
            response.header.merge!(reply[1])
            halt reply.last
          end
        end

        get "#{path}/?" do
          @visitors = Visitor.all
          erb :visitors
        end
      
        get "#{path}/visitor/:id" do
          @visitor = Visitor.find(params["id"])
          erb :visitor
        end
      
        helpers do
          define_method(:link_to) do |text, url|
            %(<a href="#{path}#{url}">#{text}</a>)
          end
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