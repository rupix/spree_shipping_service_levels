FactoryGirl.define do
  factory :ups_ground_shipping_method, parent: :shipping_method do
    name "UPS Ground"
  end
  factory :express_mail_shipping_method, parent: :shipping_method do
    name "Express Mail"
  end
  factory :priority_mail_shipping_method, parent: :shipping_method do
    name "Priority Mail"
  end
  factory :standard_shipping_method, parent: :shipping_method do
    name "Standard Fulfilled"
  end
  factory :priority_shipping_method, parent: :shipping_method do
    name "Priority Fulfilled"
  end
end