module Rack
  module Metrics
    class Tracking
      def initialize(app, storage)
        @app = app
        @storage = storage
      end
      
      def call(env)
        track(env) do
          @app.call(env)
        end
      end
      
      def track(env)
        visitor = find_visitor(env)
        @storage.add_entry(
          "path" => env["PATH_INFO"],
          "time" => Time.now.to_i,
          "visitor" => visitor)
        response = Response.new(yield)
        save_visitor(response, visitor)
        response.to_a
      end
      
      def find_visitor(env)
        (Request.new(env).cookies["_rack_tracking"] || @storage.next_visitor.to_s)
      end
      
      def save_visitor(response, visitor)
        response.set_cookie("_rack_tracking", visitor)
      end
    end
  end
end