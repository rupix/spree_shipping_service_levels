class AddShippingServiceLevelsToStockLocations < ActiveRecord::Migration
  def change
    create_table :spree_stock_locations_shipping_service_levels do |t|
      t.integer :stock_location_id
      t.integer :shipping_service_level_id
      t.index :stock_location_id, name: "stock_locations_service_levels_location_id_i"
      t.index :shipping_service_level_id, name: "stock_locations_service_levels_level_id_i"
    end
  end
end
