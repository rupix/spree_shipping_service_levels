module Spree
  module Shipping
    class RatesBuilder
      
      def initialize(package)
        @package = package
        @stock_location = package.stock_location
      end

      def shipping_rates
        sorted_unique_rates_for_service_levels
      end

      private

      attr_accessor :package, :stock_location

      def sorted_unique_rates_for_service_levels
        sorted_rates_for_service_levels.uniq{|r|r.shipping_method}
      end

      def sorted_rates_for_service_levels
        rates_for_service_levels.sort do |rate_a, rate_b|
          rate_a.shipping_service_level.days_to_deliver_max <=> rate_b.shipping_service_level.days_to_deliver_max
        end
      end

      def rates_for_service_levels
        service_levels.map do |service_level|
          rate = cheapest_rate_for_service_level(service_level)
          if rate
            rate.shipping_service_level = service_level
          end
          rate
        end.compact
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
        viable_calculated_rates(service_level.processing_days).select do |rate|
          rate_tester(service_level).passes_with?(rate)
        end
      end

      def viable_calculated_rates(processing_days)
        @rates_for_processing_days ||= {}
        @rates_for_processing_days[processing_days] ||= begin
          viable_shipping_methods.map do |shipping_method|
            rate_for(shipping_method, processing_days)
          end
        end
      end

      def viable_shipping_methods
        @viable_shipping_methods ||= package.stock_location.shipping_methods.select do |method|
          viable_shipping_method?(method)
        end
      end

      def viable_shipping_method?(method)
        method.can_ship_to?(package.order.ship_address) && method.can_ship?(package)
      end

      def rate_for(shipping_method, processing_days)
        RateBuilder.new(package, shipping_method, ship_time(processing_days)).rate
      end

      def ship_time(processing_days)
        @ship_times ||= {}
        @ship_times[processing_days] ||= calculate_ship_time(processing_days)
      end

      def calculate_ship_time(processing_days)
        ShipTimeCalculator.new(
          Time.now,
          stock_location.same_day_cutoff_hour,
          stock_location.latest_daily_ship_hour,
          processing_days,
          stock_location.processing_blackout
        ).ship_time
      end

      def rate_tester(service_level)
        @rate_testers ||= {}
        @rate_testers[service_level] ||= ServiceLevelRateTester.new(service_level, ship_time(service_level.processing_days))
      end   

    end
  end
end