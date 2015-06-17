module Spree
  class ShippingServiceLevel < ActiveRecord::Base
  	has_many :shipping_service_level_offerings
  	has_many :stock_locations, through: :shipping_service_level_offerings
    has_many :shipping_rates

    def delivery_blackout
      @delivery_blackout ||= Spree::Shipping::Blackout.from_strings(delivery_blackout_days, delivery_blackout_dates)
    end

  end
end