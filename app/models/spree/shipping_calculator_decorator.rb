Spree::ShippingCalculator.class_eval do
  preference :rate_daily_expiration_hour, :decimal, default: nil

  def rate_daily_expiration_hour
    preferred_rate_daily_expiration_hour
  end
end