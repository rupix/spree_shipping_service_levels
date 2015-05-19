module Spree
  module Package
    class ShippingRatesBuilder
      
      def initialize(order, package)
        @order = order
        @package = package
      end

      def shipping_rates
        rates_for_service_levels
      end

      private

      attr_accessor :package, :order

      def viable_shipping_methods
        package.stock_location.shipping_methods.select do |method|
          viable_shipping_method?(method)
        end
      end

      def viable_shipping_method?(method)
        method.can_ship_to?(order.ship_address) && method.can_ship?(package)
      end

      def viable_calculated_rates
        viable_shipping_methods.map do |method|
          method.rate_for(order, package)
        end
      end

      def rates_for_service_levels
        service_levels.map do |service_level|
          cheapest_rate_for_service_level(service_level)
        end
      end

      def cheapest_rate_for_service_level(service_level)
        rates_for_service_level(service_level).inject do |cheapest, rate|
          rate.cost < cheapest.cost ? rate : cheapest
        end
      end

      def service_levels
        package.stock_location.shipping_service_levels
      end

      def rates_for_service_level(service_level)
        viable_calculated_rates.select do |rate|
          service_level.met_by?(rate)
        end
      end

    end
  end
end