require 'mongo_mapper/scope'

module MongoMapper
  module NamedScope
    
    def self.included(model)
      model.class_eval do
        extend ClassMethods
      end
    end
    
    module ClassMethods
      
      def named_scope(name, conditions)
        scopes[name] = conditions
        define_scope_sugar(name, conditions)
      end
      
      def scopes
        @scopes ||= {}
      end
      
      def define_scope_sugar(name, conditions)
        instance_eval <<-RUBY
          def #{name}
            scope.add_condition(scopes[:#{name}])
            self
          end
        RUBY
      end
      
      def scope
        @scope ||= MongoMapper::Scope.new
      end
      
    end
    
  end
end