module Spree::Shipping
  class ServiceLevelRateTester

    def initialize(service_level, ship_time)
      @service_level = service_level
      @ship_time = ship_time
    end

    def passes_with?(rate)
      rate && meets_latest_delivery_date_with?(rate)
    end

    private

    attr_reader :service_level, :rate, :ship_time

    def meets_latest_delivery_date_with?(rate)
      rate.delivery_window.end <= latest_deliver_date || (rate && rate.delivery_window && rate.delivery_window.end.nil?)
    end

    def latest_deliver_date
      @latest_deliver_date ||= begin
        delivery_time_adjuster.adjusted_date(ship_time, service_level.max_deliver_days)
      end
    end

    def delivery_time_adjuster
      TimeAdjuster.new(service_level.delivery_blackout)
    end

  end
end