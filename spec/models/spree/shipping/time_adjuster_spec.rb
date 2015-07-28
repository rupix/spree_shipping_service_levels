require 'spec_helper'

module Spree::Shipping
  describe TimeAdjuster do
    let(:adjuster){build(:time_adjuster)}
    let(:days){2}

    context '#adjusted_date' do
      it 'calculates correctly with a start time that is a blacked out date' do
        start_time = DateTime.new(2015,12,25,12,30,00)
        expect(adjuster.adjusted_date(start_time, days)).to eq(DateTime.new(2015,12,29,12,30,00))
      end
      it 'calculates correctly with a start time that is a blacked out weekday' do
        start_time = DateTime.new(2015,8,2,12,30,00)
        expect(adjuster.adjusted_date(start_time, days)).to eq(DateTime.new(2015,8,4,12,30,00))
      end

      context 'with slow processing' do
        let(:days){4}
        it 'calculates correctly with processing straddling consecutive blacked out days' do
          start_time = DateTime.new(2015,12,22,12,30)
          expect(adjuster.adjusted_date(start_time, days)).to eq(DateTime.new(2015,12,30,12,30,00))
        end
      end
      
      context 'with over 9 processing days' do
        let(:days){10}
        it 'adds the time for both weekends' do
          start_time = DateTime.new(2015,6,8,11,30)
          expect(adjuster.adjusted_date(start_time, days)).to eq(DateTime.new(2015,6,22,11,30))
        end
      end
    end
  end
end