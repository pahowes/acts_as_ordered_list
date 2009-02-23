require 'test/unit'
require 'test_helper'

class ActsAsOrderedListTest < Test::Unit::TestCase

  # Creates the test database table and class, then adds several entities to the table.
  def setup
    setup_db
    (1..6).each { OrderTest.create! }
  end

  # Deletes the database tables.
  def teardown
    teardown_db
  end
  
  # Order values must be unique.
  def test_must_have_unique_order    
    t2 = OrderTest.new    # The initalizer automatically sets the value of the order member.
    assert t2.valid?
    assert t2.save

    t1 = OrderTest.new
    t1.order = 1          # This should fail because of the entities created during setup.
    assert !t1.valid?
  end

  # OrderTests the effect of the change_order method when the entity is moved down in the order.
  def test_change_order_down
    OrderTest.change_order(5, 2)
    assert_equal(2, OrderTest.find(5).order)
    assert_equal(3, OrderTest.find(2).order)
    assert_equal(4, OrderTest.find(3).order)
    assert_equal(5, OrderTest.find(4).order)
  end  

  # OrderTests the effect of the change_order method when the entity is moved up in the order.
  def test_reorder_up
    OrderTest.change_order(2, 5)
    assert_equal(2, OrderTest.find(3).order)
    assert_equal(3, OrderTest.find(4).order)
    assert_equal(4, OrderTest.find(5).order)
    assert_equal(5, OrderTest.find(2).order)
  end

  # OrderTests the effect of deleting an entity using the class delete method.
  def test_must_reorder_on_class_delete
    expected = OrderTest.maximum('"order"').to_i - 1
    OrderTest.delete(2)
    actual = OrderTest.maximum('"order"').to_i
    assert_equal(expected, actual)
  end
  
  # OrderTests the effect of deleting an entity using the instance delete method.
  def test_must_reorder_on_instance_delete
    expected = OrderTest.maximum('"order"').to_i - 1
    t = OrderTest.find(2)
    t.delete
    actual = OrderTest.maximum('"order"').to_i
    assert_equal(expected, actual)
  end
  
end
