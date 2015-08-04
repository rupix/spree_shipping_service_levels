FactoryGirl.define do
  factory :shipping_rates_builder, class: Spree::Shipping::RatesBuilder do
    initialize_with{new(package)}
    package {build(:stock_package_with_contents)}
  end
end