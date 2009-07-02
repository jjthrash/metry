require 'rufus/edo'

require 'rubygems'
require 'rufus/tokyo'

require 'fileutils'

module Metry
  class Tokyo
    def initialize(file, interface="Edo")
      FileUtils.mkdir_p(::File.dirname(file))
      @events = Rufus.const_get(interface)::Table.new(file + ".events.tdb")
      @meta = Rufus.const_get(interface)::Cabinet.new(file + ".meta.tch")
    end
    
    def next_visitor
      @meta.incr("visitor")
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
    end
  end
end
