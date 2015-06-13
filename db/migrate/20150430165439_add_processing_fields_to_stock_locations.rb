class AddProcessingFieldsToStockLocations < ActiveRecord::Migration
  def change
    add_column :spree_stock_locations, :processing_blackout_days, :string, default: ""
    add_column :spree_stock_locations, :processing_blackout_dates, :string, default: ""
    add_column :spree_stock_locations, :same_day_cutoff_hour, :float, default: 720 
    add_column :spree_stock_locations, :latest_daily_ship_hour, :float, default: 1080
  end
end
