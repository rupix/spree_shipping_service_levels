class AddShippingMethodsToStockLocations < ActiveRecord::Migration
  def change
    create_table :spree_stock_locations_shipping_methods do |t|
      t.integer :stock_location_id
      t.integer :shipping_method_id
      t.index :stock_location_id, name: "stock_locations_stock_location_id_index"
      t.index :shipping_method_id, name: "stock_locations_shipping_method_id_index"
    end
  end
end
