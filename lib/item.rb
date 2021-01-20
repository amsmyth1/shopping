class Item
  attr_reader :name, :price

  def initialize(information)
    @name = information[:name]
    @price = clean_price(information[:price])
  end

  def clean_price(price)
    price.delete("$").to_f
  end
end
