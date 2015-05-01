FactoryGirl.define do
  factory :shipping_service_level, class: Spree::ShippingServiceLevel do
    name "2-Day Shipping"
    processing_days 0
    days_to_deliver_min 2
    days_to_deliver_max 2
    delivery_blackout_dates "12/25"
    delivery_blackout_days "0,6"
    guaranteed true
    # after(:create) do |shipping_service_level, evaluator|
    #   stock_location = build(:stock_location_with_processing_info)
    #   shipping_service_level.stock_locations << stock_location
    # end
    # association :stock_location, stock_location {}
  end
end