Spree::ShippingMethod.class_eval do
  has_many :shipping_method_offerings
  has_many :stock_locations, through: :shipping_method_offerings

  def can_ship_to?(address)
    include?(address)
  end

  def can_ship?(package)
    true
  end

  def rate_for(package)
    delivery_window = calculate_delivery_window(package)
    shipping_rates.new(
      cost: package_cost(package),
      tax_rate: package_tax_rate,
      delivery_window_start: delivery_window.start,
      delivery_window_end: delivery_window.end
    )
  end

  private

  def package_cost(package)
    calculator.compute_package(package)
  end

  # See https://github.com/spree/spree/blob/2-4-stable/core/app/models/spree/stock/estimator.rb#L33-L40
  def package_tax_rate
    if tax_category
      tax_category.tax_rates.detect do |rate|
        # If the rate's zone matches the order's zone, a positive adjustment will be applied.
        # If the rate is from the default tax zone, then a negative adjustment will be applied.
        # See the tests in shipping_rate_spec.rb for an example of this.d
        rate.zone == order.tax_zone || rate.zone.default_tax?
      end
    end
  end

  def calculate_delivery_window(package)
    calculator.estimate_delivery_window(package)
  end

end