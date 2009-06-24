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
    
    module Storage
      class Marshal
        def initialize(file)
          @file = file
        end
        
        def open
          hash = if ::File.exist?(@file)
            ::Marshal.load(::File.read(@file))
          else
            {"visitor_counter" => -1, "entries" => {}}
          end
          result = yield(hash)
          ::File.open(@file, 'w'){|f| f.write ::Marshal.dump(hash)}
          result
        end
        
        def next_visitor
          open do |hash|
            hash["visitor_counter"] += 1
          end
        end
        
        def add_entry(entry)
          open do |hash|
            entries = hash["entries"]
            entries[entries.size] = entry
          end
        end
      end
    end
  end
end