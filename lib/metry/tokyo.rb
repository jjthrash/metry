require 'rubygems'
require 'rufus/tokyo'
require 'rufus/edo'

require 'fileutils'

module Metry
  class Tokyo
    EVENT_PREFIX = "event_"
    VISITOR_PREFIX = "visitor_"
    META_PREFIX = "meta_"
    
    def initialize(file, interface="Edo")
      FileUtils.mkdir_p(::File.dirname(file))
      @file = "#{file}.tdb"
      @store = Rufus.const_get(interface)::Table
    end
    
    def next_visitor
      write do |storage|
        storage.incr("#{META_PREFIX}visitor")
      end
    end
    
    def visitor(id)
      read do |storage|
        (storage[visitor_id(id)] || {})
      end
    end
    
    def save_visitor(id, hash)
      write do |storage|
        storage[visitor_id(id)] = hash
      end
    end
    
    def <<(event)
      write do |storage|
        storage[next_event_id(storage)] = event.inject({}){|a,(k,v)| a[k] = v.to_s; a}
      end
    end
    
    def [](id)
      read do |storage|
        storage[event_id(id)]
      end
    end
    
    def event_count
      read do |storage|
        storage.keys(:prefix => EVENT_PREFIX).size
      end
    end
    
    def last_events(count=1)
      read do |storage|
        storage.query do |q|
          q.add '', :starts_with, EVENT_PREFIX
          q.order_by "time", :numdesc
          q.limit count
        end.to_a
      end
    end
    
    def all_events
      read do |storage|
        storage.query do |q|
          q.add '', :starts_with, EVENT_PREFIX
        end.to_a
      end
    end
    
    def clear
      write do |storage|
        storage.clear
      end
    end
    
    private
    
    def next_event_id(storage)
      event_id(storage.incr("#{META_PREFIX}event"))
    end
    
    def access(mode)
      storage = @store.new(@file, :mode => mode)
      begin
        result = yield(storage)
      ensure
        storage.close
      end
      result
    end
    
    def read(&block)
      access("rc", &block)
    end
    
    def write(&block)
      access("wc", &block)
    end
    
    def visitor_id(id)
      "#{VISITOR_PREFIX}#{id}"
    end
    
    def event_id(id)
      "#{EVENT_PREFIX}#{id}"
    end
  end
end

module Rufus::Tokyo
  class Table
    # Increments the value stored under the given key with the given increment
    # (defaults to 1 (integer)).
    #
    # Accepts an integer or a double value.
    #
    def incr (key, inc=1)

      v = inc.is_a?(Fixnum) ?
        lib.addint(@db, key, Rufus::Tokyo.blen(key), inc) :
        lib.adddouble(@db, key, Rufus::Tokyo.blen(key), inc)

      raise(TokyoError.new(
        "incr failed, there is probably already a string value set " +
        "for the key '#{key}'"
      )) if v == Rufus::Tokyo::INT_MIN || (v.respond_to?(:nan?) && v.nan?)

      v
    end
  end
end

module Rufus::Edo
  class Table
    # Increments the value stored under the given key with the given increment
    # (defaults to 1 (integer)).
    #
    def incr (key, val=1)

      v = val.is_a?(Fixnum) ? @db.addint(key, val) : @db.adddouble(key, val)

      raise(EdoError.new(
        "incr failed, there is probably already a string value set " +
        "for the key '#{key}'"
      )) unless v

      v
    end
  end
end