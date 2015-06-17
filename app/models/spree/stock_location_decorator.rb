Spree::StockLocation.class_eval do
  has_many :shipping_service_level_offerings
  has_many :shipping_service_levels, through: :shipping_service_level_offerings
  has_many :shipping_method_offerings
  has_many :shipping_methods, through: :shipping_method_offerings

  def processing_blackout
    @processing_blackout ||= Spree::Shipping::Blackout.from_strings(processing_blackout_days, processing_blackout_dates)
  end
end