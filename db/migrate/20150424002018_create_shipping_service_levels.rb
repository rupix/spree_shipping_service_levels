class CreateShippingServiceLevels < ActiveRecord::Migration
  def change
    create_table :spree_shipping_service_levels do |t|
      t.string :name
      t.integer :processing_days
      t.integer :days_to_deliver_min
      t.integer :days_to_deliver_max
      t.string :delivery_blackout_dates
      t.string :delivery_blackout_days
      t.boolean :guaranteed
    end
  end
end
