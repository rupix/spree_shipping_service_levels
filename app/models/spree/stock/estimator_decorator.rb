Spree::Stock::Estimator.class_eval do

  private

  # Returns the set of shipping methods that can be used to deliver the given package
  # of items. Takes into account any product shipping restrictions in the package as
  # well as the methods available at the package's stock location
  def shipping_methods(package, filter)
    methods = package.stock_location.shipping_methods
    methods = methods & package.shipping_methods
    methods.select do |ship_method|
      calculator = ship_method.calculator
      begin
        ship_method.available_to_display(display_filter) &&
        ship_method.include?(order.ship_address) &&
        calculator.available?(package) &&
        (calculator.preferences[:currency].blank? ||
         calculator.preferences[:currency] == currency)
      rescue Exception => exception
        log_calculator_exception(ship_method, exception)
      end
    end
  end

  
  def service_levels(package, ui_filter)
    shipping_methods(package, ui_filter).map do |shipping_method|
      
    end
  end

  def calculate_shipping_rates(package, ui_filter)
    service_levels(package, ui_filter).map do |service_level|
      shipping_method = service_level.shipping_method
      cost = shipping_method.calculator.compute(package)
      tax_category = shipping_method.tax_category
      if tax_category
        tax_rate = tax_category.tax_rates.detect do |rate|
          # If the rate's zone matches the order's zone, a positive adjustment will be applied.
          # If the rate is from the default tax zone, then a negative adjustment will be applied.
          # See the tests in shipping_rate_spec.rb for an example of this.d
          rate.zone == order.tax_zone || rate.zone.default_tax?
        end
      end
      if cost
        rate = shipping_method.shipping_rates.new(cost: cost)
        rate.tax_rate = tax_rate if tax_rate
      end
      rate
    end.compact
  end

end