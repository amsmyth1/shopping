require 'minitest/autorun'
require 'minitest/pride'
require './lib/vendor'
require './lib/item'
require './lib/market'

class MarketTest < Minitest::Test

  def setup
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
  end

  def test_it_exists
    assert_instance_of Market, @market
  end

  def test_it_has_attributes

    assert_equal "South Pearl Street Farmers Market", @market.name
    assert_equal [], @market.vendors
  end

  def test_it_can_add_vendors_and_list_by_name
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal [@vendor1, @vendor2, @vendor3], @market.vendors
    assert_equal ["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"], @market.vendor_names
  end

  def test_vendors_that_sell_items
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal [@vendor1, @vendor3], @market.vendors_that_sell(@item1)
    assert_equal [@vendor2], @market.vendors_that_sell(@item4)
  end

  def test_sorted_items_list
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    expect = ["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"]

    expect2 = {
      @item1 => {:quantity => 110, :vendors => [@vendor1, @vendor3]},
      @item2 => {:quantity => 7, :vendors => [@vendor1]},
      @item3 => {:quantity => 75, :vendors => [@vendor2, @vendor3]},
      @item4 => {:quantity => 50, :vendors => [@vendor2]}}

    assert_equal expect, @market.sorted_item_list
    assert_equal true, @market.item_duplicated?(@item1)
    assert_equal false, @market.item_duplicated?(@item4)
  end

  def test_total_inventory
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    expect = ["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"]

    expect1 = {
      @item1 => {},
      @item2 => {},
      @item3 => {},
      @item4 => {}}
    expect2 = {
      @item1 => {:quantity => 100, :vendors => [@vendor1, @vendor3]},
      @item2 => {:quantity => 7, :vendors => [@vendor1]},
      @item3 => {:quantity => 35, :vendors => [@vendor2, @vendor3]},
      @item4 => {:quantity => 50, :vendors => [@vendor2]}}

    assert_equal expect, @market.sorted_item_list
    assert_equal true, @market.item_duplicated?(@item1)
    assert_equal false, @market.item_duplicated?(@item4)
    assert_equal 100, @market.quantity(@item1)
    assert_equal 7, @market.quantity(@item2)
    assert_equal 35, @market.quantity(@item3)
    assert_equal 50, @market.quantity(@item4)
    assert_equal expect2, @market.total_inventory
  end
end
