FactoryGirl.define do
  factory :stock_location_with_processing_info, parent: :stock_location do
    processing_blackout_days "0,6"
    processing_blackout_dates "12/25"
  end
end