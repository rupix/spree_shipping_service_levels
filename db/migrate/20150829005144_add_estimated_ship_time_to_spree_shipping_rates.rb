class AddEstimatedShipTimeToSpreeShippingRates < ActiveRecord::Migration
  def change
    add_column :spree_shipping_rates, :estimated_ship_time, :datetime
  end
end
