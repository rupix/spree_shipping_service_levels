require 'spec_helper'

describe Spree::ShippingMethod, type: :model do
  let(:shipping_method){build(:shipping_method)}
  context '#rate_daily_expiration_hour' do
    before do
      allow(shipping_method.calculator).to receive(:rate_daily_expiration_hour)
    end
    it "calls rate_daily_expiration_hour on it's calculator" do
      expect(shipping_method.calculator).to receive(:rate_daily_expiration_hour)
      shipping_method.rate_daily_expiration_hour
    end
  end
end