require 'spec_helper'

describe Spree::Order, type: :model do
  let(:order){create(:order_with_line_items)}

  context '#ensure_valid_shipments' do
    
    before do
      order.create_proposed_shipments
      create(:payment, amount: order.total, order: order)
      order.state = "confirm"
      order.save!
    end

    it 'is called before the transition to complete' do
      expect(order).to receive(:ensure_valid_shipments).twice
      order.next
    end
    
    context 'with shipments' do

      context 'when a ShippingRatesExpired error is raised' do
        before do
          allow(order.shipments.first).to receive(:validate).and_raise(Spree::Shipment::ShippingRatesExpired)
        end

        it 'halts the transition to complete with an error' do
          expect{order.next}.to raise_error(Spree::Order::ShipmentValidationError)
          expect(order.state).to eq("delivery")
        end
      end

      context 'when a different error is raised' do
        before do
          allow(order.shipments.first).to receive(:validate).and_raise(StandardError)
        end
        it 'halts the transition to complete with an error' do
          expect{order.next}.to raise_error(Spree::Order::ShipmentValidationError)
          expect(order.state).to eq("address")
        end
      end

      context 'when no error is raised' do
        it 'transitions to complete' do
          order.next
          expect(order.state).to eq("complete")
        end
      end
    end
    
    context 'without shipments' do
      before do
        order.shipments.clear
      end

      it 'transitions to complete' do
        order.next
        expect(order.state).to eq("complete")
      end
    end
  end
end