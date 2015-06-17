module Spree
  module Shipping
    class RatesBuilder
      
      def initialize(package)
        @package = package
        @stock_location = package.stock_location
      end

      def shipping_rates
        rates_for_service_levels
      end

      private

      attr_accessor :package, :stock_location

      def rates_for_service_levels
        service_levels.map do |service_level|
          cheapest_rate_for_service_level(service_level)
        end
      end

      def service_levels
        stock_location.shipping_service_levels
      end

      def cheapest_rate_for_service_level(service_level)
        rates_for_service_level(service_level).inject do |cheapest, rate|
          rate.cost < cheapest.cost ? rate : cheapest
        end
      end

      def rates_for_service_level(service_level)
        viable_calculated_rates(service_level).select do |rate|
          rate_tester(service_level, stock_location).passes_with?(rate)
        end
      end

      def viable_calculated_rates(service_level)
        viable_shipping_methods.map do |shipping_method|
          rate_for(shipping_method, service_level)
        end
      end

      def viable_shipping_methods
        package.stock_location.shipping_methods.select do |method|
          viable_shipping_method?(method)
        end
      end

      def viable_shipping_method?(method)
        method.can_ship_to?(package.order.ship_address) && method.can_ship?(package)
      end

      def rate_for(shipping_method, service_level)
        RateBuilder.new(package, shipping_method, ship_time(service_level)).rate
      end

      def ship_time(service_level)
        @ship_times ||= {}
        @ship_times[service_level] ||= calculate_ship_time(service_level)
      end

      def calculate_ship_time(service_level)
        ShipTimeCalculator.new(
          Time.now,
          stock_location.same_day_cutoff_hour,
          stock_location.latest_daily_ship_hour,
          service_level.processing_days,
          stock_location.processing_blackout
        ).ship_time
      end

      def rate_tester(service_level)
        @rate_testers ||= {}
        @rate_testers[service_level] ||= ServiceLevelRateTester.new(service_level, ship_time(service_level))
      end   

    end
  end
end