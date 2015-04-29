Spree::StockLocation.class_eval do
  has_and_belongs_to_many :shipping_service_levels, join_table: "spree_stock_locations_shipping_service_levels"
  has_and_belongs_to_many :shipping_methods, join_table: "spree_stock_locations_shipping_methods"
end