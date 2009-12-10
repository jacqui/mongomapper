require 'mongo_mapper/scope'

module MongoMapper
  module NamedScope
    
    def self.included(model)
      model.class_eval do
        extend ClassMethods
      end
    end
    
    module ClassMethods
      
      def named_scope(name, specification)
        scopes[name] = specification
        case specification
        when Hash
          define_static_scope(name, specification)
        when Proc
          define_dynamic_scope(name, specification)
        end
      end
      
      def scopes
        @scopes ||= {}
      end
      
      def define_static_scope(name, conditions)
        instance_eval <<-RUBY
          def #{name}
            scope.add_condition(scopes[:#{name}])
            self
          end
        RUBY
      end
      
      def define_dynamic_scope(name, conditions)
        instance_eval <<-RUBY
          def #{name}(*args)
            scope.add_condition(scopes[:#{name}].call(*args))
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
