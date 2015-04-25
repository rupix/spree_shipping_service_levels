module Spree
  class ShippingServiceLevel < ActiveRecord::Base
    has_and_belongs_to_many :stock_locations
    has_many :shipping_rates
  end
end