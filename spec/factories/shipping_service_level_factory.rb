FactoryGirl.define do
  factory :shipping_service_level, class: Spree::ShippingServiceLevel do
    name "2-Day Shipping"
    processing_days 0
    days_to_deliver_min 0
    days_to_deliver_max 2
    delivery_blackout_dates ""
    delivery_blackout_days ""
    guaranteed true

    factory :slow_processing_shipping_service_level do
      processing_days 4
    end

    factory :super_slow_processing_shipping_service_level do
      processing_days 10
    end

    factory :standard_shipping_service_level do
      name "Standard"
      processing_days 1
      days_to_deliver_min 3
      days_to_deliver_max 7
      guaranteed false
    end

    factory :two_day_shipping_service_level do

    end

    factory :three_day_shipping_service_level do
      name "3-Day"
      days_to_deliver_min 0
      days_to_deliver_max 3
    end

    factory :next_day_shipping_service_level do
      name "Next Day"
      days_to_deliver_min 0
      days_to_deliver_max 1
    end
  end
end