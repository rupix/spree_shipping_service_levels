module Spree
  class Order::ShipmentValidationError < StandardError; end
  Order.class_eval do
    state_machines[:state].before_transition to: :complete, do: :ensure_valid_shipments

    alias_method :orig_process_payments!, :process_payments!
    def process_payments!
      ensure_valid_shipments
      orig_process_payments!
    end
    
    private

    def ensure_valid_shipments
      if shipments.any?
        begin
          shipments.each(&:validate)
        rescue Shipment::ShippingRatesExpired => e
          errors.add(:base, Spree.t(:expired_shipping_rates_error))
          create_proposed_shipments
          self.state = "delivery"
          self.save
          raise Order::ShipmentValidationError.new, ["At least one shipping rate has expired!", e]
        rescue Exception => e
          errors.add(:base, Spree.t(:shipment_validation_error))
          restart_checkout_flow
          raise Order::ShipmentValidationError.new, ["Error validating shipments!", e]
        else
          true
        end
      else
        true
      end
    end
  end
end