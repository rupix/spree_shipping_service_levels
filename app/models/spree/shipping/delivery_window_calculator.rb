module Spree
  module Shipping
    class DeliveryWindowCalculator

      def initialize(package, shipping_method, service_level, order_time)
        @package = package
        @stock_location = package.stock_location
        @shipping_method = shipping_method
        @calculator = shipping_method.calculator
        @service_level = service_level
        @order_time = order_time
      end

      def delivery_window
        if calculated_by_fulfiller?
          fulfiller_delivery_window
        else
          carrier_delivery_window
        end
      end

      private

      attr_accessor :package, :stock_location, :shipping_method, :calculator, :service_level, :order_time

      def calculated_by_fulfiller?
        calculator.respond_to?(:fulfillment_provider)
      end

      def fulfiller_delivery_window
        @fulfiller_delivery_window ||= calculator.estimate_delivery_window(package)
      end

      def carrier_delivery_window
        @carrier_delivery_window ||= begin
          calculator.estimate_delivery_window(package, ship_time)
        end
      end

      def ship_time
        @ship_time ||= begin
          order_time + days_to_ship.days
        end
      end

      def days_to_ship
        processing_days = service_level.processing_days
        if after_same_day_cutoff? || order_date_blacked_out?
          processing_days += 1
        end
        days_adjusted_for_blackouts(
          order_time,
          processing_days,
          stock_location.processing_blackout_days.split(','),
          stock_location.processing_blackout_dates.split(',')
        )
      end

      def after_same_day_cutoff?
        Time.now < Time.now.beginning_of_day + stock_location.same_day_cutoff_minute.minutes
      end

      def order_date_blacked_out?
        dates_contain(stock_location.processing_blackout_dates.split(','), order_time) || 
        days_contain(stock_location.processing_blackout_days.split(','), order_time)
      end   

      def days_adjusted_for_blackouts(start, days, blackout_days, blackout_dates)
        valid_days = 0
        adjusted_days = 0
        current_date = start
        while valid_days < days
          current_date += 1.day 
          adjusted_days += 1
          if !(dates_contain(blackout_dates, current_date) || days_contain(blackout_days, current_date))
            valid_days += 1
          end             
        end
        adjusted_days
      end

      def dates_contain(dates, test_date)
        matches = dates.select do |date|
          date_parts = date.split('/')
          month = date_parts[0].to_i
          day = date_parts[1].to_i
          test_date.month == month && test_date.day == day
        end
        matches.any?
      end

      def days_contain(days, test_date)
        days.include?(test_date.wday.to_s)
      end

    end
  end
end