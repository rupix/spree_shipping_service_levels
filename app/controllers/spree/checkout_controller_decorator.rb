Spree::CheckoutController.class_eval do
  around_action :catch_shipment_validation_errors, only: [:update]

  private

  def catch_shipment_validation_errors
    begin
      yield
    rescue Spree::Order::ShipmentValidationError => e
      flash.now[:error] = e.cause.message
      render :edit
    end
  end
end