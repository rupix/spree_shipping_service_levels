Spree::StockLocation.class_eval do
  has_many :shipping_service_level_offerings
  has_many :shipping_service_levels, through: :shipping_service_level_offerings
  has_many :shipping_method_offerings
  has_many :shipping_methods, through: :shipping_method_offerings
end