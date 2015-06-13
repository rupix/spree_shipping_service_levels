FactoryGirl.define do
  factory :shipping_service_level, class: Spree::ShippingServiceLevel do
    name "2-Day Shipping"
    processing_days 0
    days_to_deliver_min 2
    days_to_deliver_max 2
    delivery_blackout_dates "12/25"
    delivery_blackout_days "0,6"
    guaranteed true

    factory :slow_processing_shipping_service_level do
      processing_days 4
    end

    factory :super_slow_processing_shipping_service_level do
      processing_days 10
    end
  end
end