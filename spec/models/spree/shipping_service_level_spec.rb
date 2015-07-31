require 'spec_helper'

describe Spree::ShippingServiceLevel, type: :model do
  let(:service_level){create(:shipping_service_level)}
  let(:package){build(:stock_package_with_contents)}
end