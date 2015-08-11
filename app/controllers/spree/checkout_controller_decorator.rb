Spree::CheckoutController.class_eval do
  before_action :check_for_expired_shipping_rates
  around_action :catch_shipment_validation_errors_filter, only: [:update]

  private

  def check_for_expired_shipping_rates
    catch_shipment_validation_errors do
      @order.ensure_valid_shipments
    end
  end

  def catch_shipment_validation_errors_filter
    catch_shipment_validation_errors do
      yield
    end
  end

  def catch_shipment_validation_errors
    begin
      yield
    rescue Spree::Order::ShipmentValidationError => e
      flash.now[:error] = e.cause.message
      render :edit
    end
  end
end