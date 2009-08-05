require 'mongo'

module Metry
  class Storage
    include XGen::Mongo::Driver
    
    @predictable_keys = false
    class << self
      def predictable_keys?
        @predictable_keys
      end
      
      def predictable_keys=(value)
        @predictable_keys = value
        Metry.init Metry.current.dbname if Metry.current
      end
    end
    
    attr_reader :dbname
    
    def initialize(dbname)
      @dbname = dbname
      options = {}
      @key_factory = nil
      if self.class.predictable_keys?
        @key_factory = PredictableKeyFactory.new
        options[:pk] = @key_factory
      end
      @db = Mongo.new('localhost').db(dbname, options)
    end

    def visitor(id)
      @db.collection('visitors').find(:_id => id).next_object
    end

    def visitor_count
      @db.collection('visitors').count
    end

    def visitors
      @db.collection('visitors').find
    end
    
    def new_visitor
      id = @db.collection('visitors').insert({})
      visitor(id)
    end

    def save_visitor(visitor)
      @db.collection('visitors').repsert({:_id => visitor["_id"]}, visitor)
    end

    def <<(event)
      @db.collection('events') << event
    end

    def [](id)
      @db.collection('events').find(:_id => id).next_object
    end

    def event_count
      @db.collection('events').count
    end

    def events_for(visitor)
      @db.collection('events').find(:visitor => visitor)
    end
    
    def last_events(count=1)
      @db.collection('events').find({}, :limit => count, :sort => {:time => 1}).to_a
    end

    def all_events(*find_options)
      @db.collection('events').find(*find_options).to_a
    end

    def clear
      %w(visitors events).each{|e| @db.drop_collection(e)}
      @key_factory.clear if @key_factory
    end
    
    class PredictableKeyFactory
      def initialize
        clear
      end

      def create_pk(row)
        return row if row[:_id]
        row.delete(:_id)      # in case it exists but the value is nil
        row['_id'] ||= (row["event"] ? (@event_id+=1) : (@other_id+=1)).to_s
        row
      end
      
      def clear
        @event_id = 0
        @other_id = 0
      end
    end
  end
end