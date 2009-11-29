require 'test_helper'
require 'models'

class NamedScopesTest < Test::Unit::TestCase
  
  def setup
    @document = Class.new do
      include MongoMapper::Document
      set_collection_name 'users'

      key :first_name, String
      key :last_name, String
      key :age, Integer
      key :date, Date
    end
    @document.collection.remove
  end
  
  context 'Named scopes' do
    
    setup { simple_scope }
    
    should 'add simple hash-based scopes' do
      assert_equal 1, @document.scopes.length
    end
    
    should 'find based on scope' do
      make_people
      assert_equal [@voter], @document.voters.all
    end
    
    should 'merge chained scopes' do
      @document.class_eval { named_scope :drapers, {:last_name => 'Draper'} }
      make_people
      @document.create(:first_name => 'Roger',
                       :last_name => 'Sterling',
                       :age => 60,
                       :date => Date.parse('1/1/1910'))
      assert_equal 1, @document.voters.drapers.all.length
    end
    
    should 'define the current scope for a document class' do
      @document.scope.should be_an_instance_of(MongoMapper::Scope)
    end
    
  end
  
  def simple_scope
    @document.class_eval do
      named_scope :voters, {:age => {'$gt' => 18}}
    end
  end
  
  def make_people
    @non_voter = @document.create(:first_name => 'Sally', 
                                 :last_name => 'Draper', 
                                 :age => 10, 
                                 :date => Date.parse('1/1/1950'))
    @voter = @document.create(:first_name => 'Don', 
                             :last_name => 'Draper', 
                             :age => 40, 
                             :date => Date.parse('1/1/1920'))
  end
  
end