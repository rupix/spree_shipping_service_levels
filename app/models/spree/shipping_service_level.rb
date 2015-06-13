module Spree
  class ShippingServiceLevel < ActiveRecord::Base
  	has_many :shipping_service_level_offerings
  	has_many :stock_locations, through: :shipping_service_level_offerings
    has_many :shipping_rates
  end
end