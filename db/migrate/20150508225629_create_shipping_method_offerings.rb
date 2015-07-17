class CreateShippingMethodOfferings < ActiveRecord::Migration
  def change
    create_table :spree_shipping_method_offerings do |t|
      t.belongs_to :shipping_method
      t.belongs_to :stock_location
    end

    add_index :spree_shipping_method_offerings, :shipping_method_id, name: 'shipping_method_offerings_method_index'
    add_index :spree_shipping_method_offerings, :stock_location_id, name: 'shipping_method_offerings_stock_location_index'
  end
end
