require 'test_helper'

class NamedScopesTest < Test::Unit::TestCase
  
  def setup
    @document = Class.new do
      include MongoMapper::Document
      set_collection_name 'users'

      key :first_name, String
      key :last_name, String
      key :age, Integer
      key :date, Date
      
      named_scope :voters, {:age => {'$gt' => 18}}
      named_scope :younger_than, lambda { |age| 
        {:conditions => {'age' => {'$lt' => age}}}
      }
      named_scope :named, lambda { |first_name, last_name|
        {:conditions => {'first_name' => first_name, 
                         'last_name' => last_name}}
      }
    end
    
    @document.collection.remove
    make_people
  end
  
  context 'Static scopes' do
    
    should 'add hash-based scopes' do
      lambda {
        @document.class_eval do
          named_scope :don, {:conditions => {:first_name => 'Don'}}
        end
      }.should change { @document.scopes.length }.by(1)
    end
    
    should 'find based on scope' do
      @document.voters.all.length.should == 2
    end
    
    should 'merge chained scopes' do
      @document.class_eval { named_scope :drapers, {:last_name => 'Draper'} }
      @document.voters.drapers.all.length.should == 1
    end
    
    should 'define the current scope for a document class' do
      @document.scope.should be_an_instance_of(MongoMapper::Scope)
    end
    
  end
  
  context 'Dynamic scopes' do
    
    should 'execute a block' do
      @document.younger_than(50).all.length.should == 2
    end
    
    should 'merge with static scopes' do
      @document.younger_than(50).voters.all.length.should == 1
    end
    
    should 'merge with dynamic scopes' do
      @document.younger_than(50).named('Don', 'Draper').all.length.should == 1
    end
    
  end
  
  context 'Scopes' do
    
    should 'apply to .all' do
      @document.voters.all.length.should == 2
    end
    
    should 'apply to .first' do
      @document.voters.first.first_name.should == 'Don'
    end
    
    should 'apply to .last' do
      @document.voters.last(:order => 'last_name').first_name.
        should == 'Roger'
    end
    
    should 'apply to .count' do
      @document.voters.count.should == 2
    end
    
    should 'apply to .find' do
      @document.voters.find!(:all, :conditions => {:first_name => 'Don'}).length.should == 1
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
    @document.create(:first_name => 'Roger',
                     :last_name => 'Sterling',
                     :age => 60,
                     :date => Date.parse('1/1/1910'))
  end
  
end