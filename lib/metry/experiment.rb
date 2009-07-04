module Metry
  class Experiment
    METHODS = {
      "rand" => proc{|list, visitor| list.sort_by{rand}.first},
      "mod_visitor" => proc{|list, visitor| list[(visitor.to_i-1)%list.size]},
    }

    def initialize(name, event, storage)
      @key = "experiment.#{name}"
      @event = event
      @visitor = event["visitor"]
      @storage = storage
    end
    
    def choose(options, method=nil)
      visitor_hash = @storage.visitor(@visitor)
      unless choice = visitor_hash[@key]
        choice = METHODS[method || "rand"][options.keys, @visitor]
        @storage.save_visitor(@visitor, visitor_hash.merge(@key => choice))
      end
      @event[@key] = choice
      options[choice]
    end
  end
end