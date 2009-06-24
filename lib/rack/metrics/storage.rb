module Rack
  module Metrics
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