require 'minitest/autorun'
require 'minitest/pride'
require './lib/vendor'
require './lib/item'

class VendorTest < Minitest::Test

  def setup
    @vendor = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
  end

  def test_it_exists


    assert_instance_of Vendor, @vendor
  end

  def test_it_has_attributes

    assert_equal "Rocky Mountain Fresh", @vendor.name
    assert_equal ({}), @vendor.inventory
  end

  def test_it_can_check_stock_and_add_stock

    assert_equal 0, @vendor.check_stock(@item1)
    assert_equal false, @vendor.in_stock?(@item1)

    @vendor.stock(@item1, 30)
    expect = {@item1 => 30}

    assert_equal expect, @vendor.inventory
    assert_equal 30, @vendor.check_stock(@item1)
    assert_equal true, @vendor.in_stock?(@item1)

    @vendor.stock(@item1, 25)
    @vendor.stock(@item2, 12)
    expect = {@item1 => 55, @item2 => 12}

    assert_equal 55, @vendor.check_stock(@item1)
    assert_equal expect, @vendor.inventory
  end

  def test_for_potential_revenue
    @vendor.stock(@item1, 25) #0.75
    @vendor.stock(@item2, 12) #0.50

    assert_equal (18.75 + 6), @vendor.potential_revenue
    @vendor.stock(@item1, 10) #0.75

    assert_equal (18.75 + 6 + 7.5), @vendor.potential_revenue
  end
end
