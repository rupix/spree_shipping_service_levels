class AddExpiresAtToSpreeShippingRates < ActiveRecord::Migration
  def change
    add_column :spree_shipping_rates, :expires_at, :datetime
  end
end
