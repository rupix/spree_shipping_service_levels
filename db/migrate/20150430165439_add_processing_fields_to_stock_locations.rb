class AddProcessingFieldsToStockLocations < ActiveRecord::Migration
  def change
    add_column :spree_stock_locations, :processing_blackout_days, :string, default: ""
    add_column :spree_stock_locations, :processing_blackout_dates, :string, default: ""
    add_column :spree_stock_locations, :same_day_cutoff_minute, :integer, default: 720 
  end
end
