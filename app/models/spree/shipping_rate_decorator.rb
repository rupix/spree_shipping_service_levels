Spree::ShippingRate.class_eval do
  belongs_to :shipping_service_level

  def delivery_window
    @delivery_window ||= Spree::Shipping::DeliveryWindow.new(delivery_window_start, delivery_window_end)
  end

  def delivery_window=(delivery_window)
    write_attribute(:delivery_window_start, delivery_window.start)
    write_attribute(:delivery_window_end, delivery_window.end)
  end

  def expired?
    expires_at ? expires_at < DateTime.now : false
  end
end