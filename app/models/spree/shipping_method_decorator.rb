Spree::ShippingMethod.class_eval do
  has_many :shipping_method_offerings
  has_many :stock_locations, through: :shipping_method_offerings
end