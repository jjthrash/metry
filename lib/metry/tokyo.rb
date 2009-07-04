require 'rufus/edo'

require 'rubygems'
require 'rufus/tokyo'

require 'fileutils'

module Metry
  class Tokyo
    def initialize(file, interface="Edo")
      FileUtils.mkdir_p(::File.dirname(file))
      store = Rufus.const_get(interface)
      @events = store::Table.new(file + ".events.tdb")
      @meta = store::Cabinet.new(file + ".meta.tch")
      @visitors = store::Table.new(file + ".visitors.tdb")
    end
    
    def next_visitor
      @meta.incr("visitor")
    end
    
    def visitor(id)
      (@visitors[id] || {})
    end
    
    def save_visitor(id, hash)
      @visitors[id] = hash
    end
    
    def next_event_id
      @meta.incr("event", 1).to_s
    end
    
    def <<(event)
      @events[next_event_id] = event.inject({}){|a,(k,v)| a[k] = v.to_s; a}
    end
    
    def [](id)
      @events[id.to_s]
    end
    
    def event_count
      @events.size
    end
    
    def clear
      @events.clear
      @meta.clear
      @visitors.clear
    end
  end
end
