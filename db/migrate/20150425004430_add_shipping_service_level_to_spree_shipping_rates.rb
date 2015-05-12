class AddShippingServiceLevelToSpreeShippingRates < ActiveRecord::Migration
  def change
    add_column :spree_shipping_rates, :shipping_service_level_id, :integer, default: nil
  end
end
