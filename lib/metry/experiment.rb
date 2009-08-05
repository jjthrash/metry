module Metry
  class Experiment
    METHODS = {
      "rand" => proc{|list, visitor| list.sort_by{rand}.first},
      "mod_visitor" => proc{|list, visitor| list[(visitor['_id'].to_i-1)%list.size]}, # mod_visitor will only work with predictable_keys = true
    }

    def initialize(name, event, visitor)
      @key = "experiment:#{name}"
      @event = event
      @visitor = visitor
    end
    
    def choose(options, method=nil)
      unless choice = @visitor[@key]
        choice = METHODS[method || "rand"][options.keys, @visitor]
        @visitor[@key] = choice
      end
      @event[@key] = choice
      options[choice]
    end
  end
end