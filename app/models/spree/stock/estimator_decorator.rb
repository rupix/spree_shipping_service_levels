Spree::Stock::Estimator.class_eval do

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

end