require 'spec_helper'

module Spree::Shipping
  describe Blackout do
    let(:blackout){Blackout.from_strings('0,6', '12/24,12/25')}

    context '#from_strings' do
      it 'returns an instance of blackout' do
        expect(blackout).to be_instance_of(Blackout)
        expect(blackout.weekdays).to eq(['0','6'])
        expect(blackout.dates).to eq(['12/24','12/25'])
      end
    end

    context '#date_blacked_out?' do
      it 'returns true for a date in the blackout out dates string' do
        expect(blackout.date_blacked_out?(DateTime.new(2015,12,24))).to eq(true)
      end
      it 'returns true for a date in the blackout weekdays string' do
        expect(blackout.date_blacked_out?(DateTime.new(2015,6,20))).to eq(true)
      end
      it 'returns false for a date not on a blacked out weekday or date' do
        expect(blackout.date_blacked_out?(DateTime.new(2015,6,15,))).to eq(false)
      end
    end

  end
end