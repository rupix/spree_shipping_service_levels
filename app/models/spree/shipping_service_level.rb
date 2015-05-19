module Spree
  class ShippingServiceLevel < ActiveRecord::Base
  	has_many :shipping_service_level_offerings
  	has_many :stock_locations, through: :shipping_service_level_offerings
    has_many :shipping_rates

    def met_by?(rate)

    end
  end
end