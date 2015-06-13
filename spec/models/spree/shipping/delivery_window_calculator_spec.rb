require 'spec_helper'

module Spree::Shipping
  describe DeliveryWindowCalculator do
    let(:window_calculator){klass.new(package, calculator, service_level, order_time)}
    let(:klass){DeliveryWindowCalculator}
    let(:package){build(:stock_package_fulfilled, stock_location: stock_location)}
    let(:stock_location){create(:stock_location_with_processing_info)}
    let(:calculator){double()}
    let(:service_level){create(:shipping_service_level)}
    let(:order_time){DateTime.now}
    before(:each) do
      klass.send(:public, *klass.private_instance_methods)
    end

    context '#delivery_window' do
      let(:window){DeliveryWindow.new(DateTime.now + 2.days, DateTime.now + 3.days)}
      before(:each) do
        allow(calculator).to receive(:estimate_delivery_window).and_return(window)
      end

      context 'when fulfilling via a third party' do
        before(:each) do
          allow(calculator).to receive(:fulfillment_provider)
        end        
        
        it 'returns the window provided by the fulfillment provider' do
          expect(window_calculator.delivery_window).to eq(window)
        end
      end
      
      context 'when fulfilling in-house' do
        it 'calls estimate_delivery_window on the calculator with the ship_time' do
          ship_time = double("ship_time")
          allow(window_calculator).to receive(:ship_time).and_return(ship_time)
          window_calculator.delivery_window
          expect(calculator).to have_received(:estimate_delivery_window).with(package, ship_time)
        end
      end

    end

    context '#ship_time' do

      def custom_window_calculator(order_time)
        klass.new(package, calculator, service_level, order_time)
      end

      it 'calculates correctly with an order date that is blacked out' do
        order_time = DateTime.new(2015,12,25,12,30,00)
        expect(custom_window_calculator(order_time).ship_time).to eq(DateTime.new(2015,12,28,18,00,00))
      end
      it 'calculates correctly with an order time that is not blacked out and created before the cutoff time' do
        order_time = DateTime.new(2015,6,10,11,30)
        expect(custom_window_calculator(order_time).ship_time).to eq(DateTime.new(2015,6,10,18,00,00))
      end
      it 'calculates correctly with an order date that is not blacked out and created after the cutoff time' do
        order_time = DateTime.new(2015,6,10,12,30)
        expect(custom_window_calculator(order_time).ship_time).to eq(DateTime.new(2015,6,11,18,00,00))
      end

      context 'with slow processing' do
        let(:service_level){create(:slow_processing_shipping_service_level)}
        it 'calculates correctly with processing straddling consecutive blacked out days' do
          order_time = DateTime.new(2015,12,22,11,30)
          expect(custom_window_calculator(order_time).ship_time).to eq(DateTime.new(2015,12,30,18,00,00))
        end
      end
      
      context 'with over 9 processing days' do
        let(:service_level){create(:super_slow_processing_shipping_service_level)}
        it 'adds the time for both weekends' do
          order_time = DateTime.new(2015,6,8,11,30)
          expect(custom_window_calculator(order_time).ship_time).to eq(DateTime.new(2015,6,22,18))
        end
      end
    end

  end
end