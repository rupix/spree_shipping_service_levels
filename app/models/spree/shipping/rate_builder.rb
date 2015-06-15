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
        delivery_window_end: delivery_window.end
      )
    end

    private

    attr_reader :package, :shipping_method, :ship_time

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
        calculator.estimate_delivery_window(package, ship_time)
      end
    end
  end
end