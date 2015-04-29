module Spree
  class ShippingServiceLevel < ActiveRecord::Base
    has_and_belongs_to_many :stock_locations, join_table: "spree_stock_locations_shipping_service_levels"
    has_many :shipping_rates
  end
end