require 'spec_helper'

# module Spree::Shipping
#   describe DeliveryWindowCalculator do
#     let(:window_calculator){klass.new(package, calculator, service_level, order_time)}
#     let(:klass){DeliveryWindowCalculator}
#     let(:package){build(:stock_package_fulfilled, stock_location: stock_location)}
#     let(:stock_location){create(:stock_location_with_processing_info)}
#     let(:calculator){double()}
#     let(:service_level){create(:shipping_service_level)}
#     let(:order_time){DateTime.now}
#     before(:each) do
#       klass.send(:public, *klass.private_instance_methods)
#     end

#     context '#delivery_window' do
#       let(:window){DeliveryWindow.new(DateTime.now + 2.days, DateTime.now + 3.days)}
#       before(:each) do
#         allow(calculator).to receive(:estimate_delivery_window).and_return(window)
#       end

#       context 'when fulfilling via a third party' do
#         before(:each) do
#           allow(calculator).to receive(:fulfillment_provider)
#         end        
        
#         it 'returns the window provided by the fulfillment provider' do
#           expect(window_calculator.delivery_window).to eq(window)
#         end
#       end
      
#       context 'when fulfilling in-house' do
#         it 'calls estimate_delivery_window on the calculator with the ship_time' do
#           ship_time = double("ship_time")
#           allow(window_calculator).to receive(:ship_time).and_return(ship_time)
#           window_calculator.delivery_window
#           expect(calculator).to have_received(:estimate_delivery_window).with(package, ship_time)
#         end
#       end
#     end

#   end
# end