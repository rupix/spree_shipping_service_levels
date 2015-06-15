Spree::Stock::Estimator.class_eval do

  private

  def calculate_shipping_rates(package, ui_filter)
    shipping_rates_builder(package).shipping_rates
  end

  def shipping_rates_builder(package)
    Spree::Shipping::RatesBuilder.new(package).shipping_rates
  end

end