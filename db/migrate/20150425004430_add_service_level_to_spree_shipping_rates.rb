class AddServiceLevelToSpreeShippingRates < ActiveRecord::Migration
  def change
    add_column :spree_shipping_rates, :service_level_id, :integer, default: nil
  end
end
