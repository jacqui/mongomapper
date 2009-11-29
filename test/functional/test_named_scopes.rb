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
      assert_equal [@voter], @document.voters
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