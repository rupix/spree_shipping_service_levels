require 'spec_helper'

describe Spree::ShippingRate, type: :model do
  let(:shipping_rate){Spree::ShippingRate.new}
  context '#expired?' do
    it 'returns true if expires_at has past' do
      shipping_rate.expires_at = DateTime.now - 1.minute
      expect(shipping_rate.expired?).to be(true)
    end

    it 'returns false if expires_at is in the future' do
      shipping_rate.expires_at = DateTime.now + 1.minute
      expect(shipping_rate.expired?).to be(false)
    end
  end
end