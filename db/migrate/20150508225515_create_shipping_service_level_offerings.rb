class CreateShippingServiceLevelOfferings < ActiveRecord::Migration
  def change
    create_table :spree_shipping_service_level_offerings do |t|
      t.belongs_to :shipping_service_level, index: true, foreign_key: true
      t.belongs_to :stock_location, index: true, foreign_key: true
    end
  end
end
