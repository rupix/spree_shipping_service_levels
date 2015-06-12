module Spree
  class ShippingServiceLevel < ActiveRecord::Base
  	has_many :shipping_service_level_offerings
  	has_many :stock_locations, through: :shipping_service_level_offerings
    has_many :shipping_rates

    def met_by?(rate)
      rate &&
      rate_meets_delivery_time(rate)
    end

    private

    def rate_meets_delivery_time(rate)
      rate.delivery_window_end <= current_delivery_window_end
    end

    def current_delivery_window_end

    end
  end
end