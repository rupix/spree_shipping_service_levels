require 'spec_helper'

describe Spree::ShippingServiceLevel, type: :model do
  let(:service_level){create(:shipping_service_level)}
  let(:package){build(:stock_package_with_contents)}
  
  context 'met_by?(shipping_rate)' do
    it 'returns false if the shipping rate doesn\'t meet the delivery date requirement'
    it 'returns true if the shipping rate does meet the delivery date requirement'
    it 'returns false if the shipping rate doesn\'t meet the guaranteed requirement'
    it 'returns true if the shipping rate does meet the guaranteed requirement'
  end
end