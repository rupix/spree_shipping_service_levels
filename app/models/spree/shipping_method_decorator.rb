Spree::ShippingMethod.class_eval do
  has_and_belongs_to_many :stock_locations, join_table: "spree_stock_locations_shipping_methods"
end