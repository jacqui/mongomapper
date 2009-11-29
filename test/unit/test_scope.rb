require 'test_helper'

class TestScope < Test::Unit::TestCase
  
  context 'A scope' do
    
    setup { @scope = MongoMapper::Scope.new }
    
    should 'track query conditions' do
      @scope.add_condition(:name => 'Avi')
      @scope.conditions.should == {:name => 'Avi'}
    end
    
    should 'merge conditions' do
      @scope.add_condition(:name => 'Avi')
      @scope.add_condition(:age => {'$gt' => 18})
      @scope.conditions.should == {:name => 'Avi', :age => {'$gt' => 18}}
    end
    
  end
  
end