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
    end
    
    context '#rate' do
      let!(:rate){builder.rate}
      it 'returns an instance of Spree::ShippingRate' do
        expect(rate).to be_instance_of(Spree::ShippingRate)
      end
      it 'has a delivery window' do
        expect(rate.delivery_window.start).to eq(delivery_window.start)
        expect(rate.delivery_window.end).to eq(delivery_window.end)
      end
      it 'requests the delivery window from the shipping method\'s calculator' do
        expect(calculator).to have_received(:estimate_delivery_window).with(package, ship_time)
      end
      it 'requests the cost from the shipping method\'s calculator' do
        expect(calculator).to have_received(:compute_package).with(package)
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
    end
  end
end