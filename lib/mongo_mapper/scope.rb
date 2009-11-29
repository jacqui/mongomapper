module MongoMapper

  class Scope
    attr_reader :conditions
    
    def initialize
      @conditions = {}
    end
    
    def add_condition(condition)
      @conditions.merge!(condition)
    end
    
  end

end