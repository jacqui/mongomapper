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
        define_scope(name, conditions)
      end
      
      def scopes
        @scopes ||= {}
      end
      
      def define_scope(name, conditions)
        instance_eval <<-RUBY
          def #{name}
            all(:conditions => scopes[:#{name}])
          end
        RUBY
      end
      
    end
    
  end
end