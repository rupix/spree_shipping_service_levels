Spree::ShippingCalculator.class_eval do
  preference :rate_daily_expiration_hour, :decimal, default: nil
end