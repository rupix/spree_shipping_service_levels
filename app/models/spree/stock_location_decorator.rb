Spree::StockLocation.class_eval do
  has_and_belongs_to_many :shipping_service_levels
  has_and_belongs_to_many :shipping_methods
end