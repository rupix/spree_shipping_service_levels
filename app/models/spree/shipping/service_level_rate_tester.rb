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
      (rate && rate.delivery_window && rate.delivery_window.end.nil?) || (rate.delivery_window.end <= latest_deliver_date.end_of_day && rate.delivery_window.start >= earliest_deliver_date.beginning_of_day)
    end

    def latest_deliver_date
      @latest_deliver_date ||= begin
        delivery_time_adjuster.adjusted_date(ship_time, service_level.days_to_deliver_max).end_of_day
      end
    end
    
    def earliest_deliver_date
      @earliest_deliver_date ||= begin
        delivery_time_adjuster.adjusted_date(ship_time, service_level.days_to_deliver_min).beginning_of_day
      end
    end

    def delivery_time_adjuster
      TimeAdjuster.new(service_level.delivery_blackout)
    end

  end
end