class CreateShippingServiceLevelOfferings < ActiveRecord::Migration
  def change
    create_table :spree_shipping_service_level_offerings do |t|
      t.belongs_to :shipping_service_level
      t.belongs_to :stock_location
    end

    add_index :spree_shipping_service_level_offerings, :shipping_service_level_id, name: 'service_level_offerings_service_level_index'
    add_index :spree_shipping_service_level_offerings, :stock_location_id, name: 'service_level_offerings_stock_location_index'
  end
end
