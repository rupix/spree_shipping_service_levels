module Spree::Shipping
  class RateBuilder

    def initialize(package, shipping_method, ship_time)
      @package = package
      @shipping_method = shipping_method
      @calculator = shipping_method.calculator
      @ship_time = ship_time
    end

    def rate
      shipping_method.shipping_rates.new(
        cost: package_cost,
        tax_rate: tax_rate,
        delivery_window_start: delivery_window.start,
        delivery_window_end: delivery_window.end,
        expires_at: expire_time
      )
    end

    private

    attr_reader :package, :shipping_method, :ship_time, :calculator

    def package_cost
      calculator.compute_package(package)
    end

    def tax_rate
      tax_category = shipping_method.tax_category
      if tax_category
        tax_category.tax_rates.detect do |rate|
          # If the rate's zone matches the order's zone, a positive adjustment will be applied.
          # If the rate is from the default tax zone, then a negative adjustment will be applied.
          # See the tests in shipping_rate_spec.rb for an example of this.d
          rate.zone == package.order.tax_zone || rate.zone.default_tax?
        end
      end
    end

    def delivery_window
      @delivery_window ||= begin
        if calculator.respond_to?(:estimate_delivery_window)
          range = calculator.estimate_delivery_window(package, ship_time)
          if range.length == 1
            range.push(range[0])
          end
          DeliveryWindow.new(range[0], range[1])
        else
          DeliveryWindow.new(nil, nil)
        end
      end
    end

    def expire_time
      expiration_hour = shipping_method.rate_daily_expiration_hour || stock_location.same_day_cutoff_hour
      return nil unless expiration_hour
      todays_cutoff = Time.zone.now.beginning_of_day + expiration_hour.hours
      if Time.zone.now < todays_cutoff
        todays_cutoff
      else
        todays_cutoff + 1.day
      end
    end

    def stock_location
      package.stock_location
    end
  end
end