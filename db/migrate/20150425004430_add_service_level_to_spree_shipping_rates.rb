class AddServiceLevelToSpreeShippingRates < ActiveRecord::Migration
  def change
    add_column :spree_shipping_rates, :service_level_id, default: nil
  end
end
