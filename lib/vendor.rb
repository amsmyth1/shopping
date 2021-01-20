class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    @inventory[item]
  end

  def stock(item, quantity)
    @inventory[item] += quantity
  end

  def potential_revenue
    @inventory.sum do |item, quantity|
      quantity * item.price
    end
  end

  def in_stock?(item)
    if @inventory[item] > 0
      true
    else
      false
    end
  end
end
