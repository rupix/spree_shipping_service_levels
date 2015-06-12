class AddDeliveryWindowToSpreeShippingRates < ActiveRecord::Migration
  def change
    add_column :spree_shipping_rates, :delivery_window_start, :datetime
    add_column :spree_shipping_rates, :delivery_window_end, :datetime
  end
end
