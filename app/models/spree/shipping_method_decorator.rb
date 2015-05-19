Spree::ShippingMethod.class_eval do
  has_many :shipping_method_offerings
  has_many :stock_locations, through: :shipping_method_offerings

  def can_ship_to?(address)
    include?(address)
  end

  def can_ship?(package)

  end

  def rate_for(order, package)
    
  end
end