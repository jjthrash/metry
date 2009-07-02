module Metry
  class Memory
    def initialize
      clear
    end
    
    def <<(event)
      @hash[:events][(@hash[:event] += 1).to_s] = event
    end
    
    def size
      @hash[:events].size
    end
    
    def [](id)
      @hash[:events][id]
    end
    
    def next_visitor
      @hash[:visitor] += 1
    end
    
    def clear
      @hash = {:events => {}, :visitor => 0, :event => 0}
    end
  end
end