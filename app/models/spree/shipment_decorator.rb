module Spree
  class Shipment::ShippingRatesExpired < StandardError; end
  Shipment.class_eval do
    def validate
      if shipping_rates.select(&:expired?).any?
        raise Shipment::ShippingRatesExpired.new Spree.t(:shipping_rates_expired)
      end
    end
  end
end



