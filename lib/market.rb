class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.select do |vendor|
      vendor.in_stock?(item)
    end
  end

  def quantity(item)
    @vendors.sum do |vendor|
      vendor.check_stock(item)
    end
  end

  def sorted_item_list
    sorted_item_list = []
    @vendors.each do |vendor|
      vendor.inventory.each do |item, quant|
        if quant > 0
          sorted_item_list << item.name
        end
      end
    end
    sorted_item_list.uniq.sort
  end

  def total_inventory
    total_inventory_items = {}
    @vendors.each do |vendor|
      vendor.inventory.each do |item, quant|
        total_inventory_items[item] = quantity_and_vendors(item)
      end
    end
    total_inventory_items.uniq.to_h
  end

  def quantity_and_vendors(item)
    quantity_and_vendors = {}
    quantity_and_vendors[:quantity] = quantity(item)
    quantity_and_vendors[:vendors] = vendors_that_sell(item)
    quantity_and_vendors
  end


  def over_stocked_items

  end

  def item_duplicated?(item)
    vendor_list = []
    @vendors.each do |vendor|
      if vendor.in_stock?(item)
        vendor_list << vendor
      end
    end
    if vendor_list.count > 1
      true
    else
      false
    end
  end
end
