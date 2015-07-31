Spree::Shipment.class_eval do

  def validate
    if shipping_rates.select(&:expired?).any?
      raise ShippingRatesExpired.new Spree.t(:shipping_rates_expired)
    end
  end
end

class Spree::Shipment::ShippingRatesExpired < StandardError; end

