require 'rubygems'
require 'active_record'
require 'active_support'
require 'active_support/test_case'
require "#{File.dirname(__FILE__)}/../init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(:version => 1) do
    create_table :order_tests do |t|
      t.integer :order
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class OrderTest < ActiveRecord::Base
  acts_as_ordered_list
end
