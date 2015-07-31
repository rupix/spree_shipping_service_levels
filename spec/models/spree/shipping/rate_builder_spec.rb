require 'spec_helper'

module Spree::Shipping
  describe RateBuilder do
    let(:builder){RateBuilder.new(package, shipping_method, ship_time)}
    let(:package){build(:stock_package_fulfilled)}
    let(:shipping_method){build(:shipping_method)}
    let(:calculator) do
      calculator = double("Calculator")
      allow(calculator).to receive(:estimate_delivery_window).and_return(delivery_window)
      allow(calculator).to receive(:compute_package)
      calculator
    end
    let(:delivery_window){DeliveryWindow.new(ship_time + 2.days, ship_time + 3.days)}
    let(:ship_time){Time.now.beginning_of_day + 18.hours}

    before(:each) do
      allow(shipping_method).to receive(:calculator).and_return(calculator)
      allow(shipping_method).to receive(:rate_daily_expiration_hour).and_return(11)
    end
    
    context '#rate' do
      let(:rate){builder.rate}
      it 'returns an instance of Spree::ShippingRate' do
        expect(rate).to be_instance_of(Spree::ShippingRate)
      end
      it 'has a delivery window' do
        expect(rate.delivery_window.start).to eq(delivery_window.start)
        expect(rate.delivery_window.end).to eq(delivery_window.end)
      end
      it 'requests the delivery window from the shipping method\'s calculator' do
        builder.rate
        expect(calculator).to have_received(:estimate_delivery_window).with(package, ship_time)
      end
      it 'requests the cost from the shipping method\'s calculator' do
        builder.rate
        expect(calculator).to have_received(:compute_package).with(package)
      end
      it 'has an expires_at time' do
        expect(rate.expires_at).not_to be_nil
      end
      
      context 'with calculator that doesn\'t estimate windows' do
        let(:calculator) do
          calculator = double("Calculator")
          allow(calculator).to receive(:compute_package)
          calculator
        end
        it 'has a nil delivery window' do
          expect(rate.delivery_window.start).to be_nil
          expect(rate.delivery_window.end).to be_nil
        end
      end

      context 'with a shipping method that has no cutoff' do
        before(:each) do
          allow(shipping_method).to receive(:rate_daily_expiration_hour).and_return(nil)
        end
        it 'should have no expire time' do
          expect(rate.expires_at).to eq(nil)
        end
      end

      context 'with stubbed Time' do
        before(:each) do
          allow(Time).to receive(:now).and_return(current_time)
        end

        context 'before the cutoff of the current day' do
          let!(:current_time){Time.new.beginning_of_day + 8.hours}
          it 'should have an expires_at time equal to the cutoff of the current day' do
            expect(rate.expires_at).to eq(Time.new.beginning_of_day + 11.hours)
          end
        end

        context 'after the cutoff of the current day' do
          let!(:current_time){Time.new.beginning_of_day + 12.hours}
          it 'should have an expires_at time equal to the cutoff tomorrow' do
            expect(rate.expires_at).to eq(Time.new.beginning_of_day + 11.hours + 1.day)
          end
        end
      end
    end
  end
end