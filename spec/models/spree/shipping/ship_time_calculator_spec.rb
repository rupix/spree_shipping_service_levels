require 'spec_helper'

module Spree::Shipping
  describe ShipTimeCalculator do
    context '#ship_time' do
      # it 'calculates correctly with a start time that is not blacked out and created before the cutoff time' do
      #   start_time = DateTime.new(2015,6,10,11,30)
      #   expect(adjuster.adjusted_date(start_time, days)).to eq(DateTime.new(2015,6,10,18,00,00))
      # end
      # it 'calculates correctly with a start time that is not blacked out and created after the cutoff time' do
      #   start_time = DateTime.new(2015,6,10,12,30)
      #   expect(adjuster.adjusted_date(start_time, days)).to eq(DateTime.new(2015,6,11,18,00,00))
      # end
    end
  end
end