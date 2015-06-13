module Spree
  module Shipping
    class DeliveryWindowCalculator

      def initialize(package, shipping_calculator, service_level, order_time)
        @package = package
        @stock_location = package.stock_location
        @calculator = shipping_calculator
        @service_level = service_level
        @order_time = order_time
        @ship_time_calculator = ShipTimeCalculator.new(
          order_time,
          stock_location.same_day_cutoff_hour,
          stock_location.latest_daily_ship_hour,
          service_level.processing_days,
          stock_location.processing_blackout_days.split(','),
          stock_location.processing_blackout_dates.split(',')
        )
      end

      def delivery_window
        if calculated_by_fulfiller?
          fulfiller_delivery_window
        else
          carrier_delivery_window
        end
      end

      private

      attr_accessor :package, :stock_location, :calculator, :service_level, :order_time, :ship_time_calculator

      def calculated_by_fulfiller?
        calculator.respond_to?(:fulfillment_provider)
      end

      def fulfiller_delivery_window
        @fulfiller_delivery_window ||= calculator.estimate_delivery_window(package)
      end

      def carrier_delivery_window
        @carrier_delivery_window ||= begin
          calculator.estimate_delivery_window(package, ship_time_calculator.ship_time)
        end
      end

    end
  end
end