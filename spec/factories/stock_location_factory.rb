FactoryGirl.define do
  factory :stock_location_with_processing_info, parent: :stock_location do
    processing_blackout_days "0,6"
    processing_blackout_dates "12/24,12/25"
    same_day_cutoff_hour 12.0
    latest_daily_ship_hour 18.0
  end
end