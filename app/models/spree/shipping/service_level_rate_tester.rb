module Spree::Shipping
  class ServiceLevelRateTester

    def initialize(service_level, stock_location)
      @service_level = service_level
      @stock_location = stock_location
    end

    def passes_with?(rate)
      rate && stock_location && meets_latest_delivery_date_with?(rate)
    end

    private

    attr_reader :service_level, :rate, :stock_location

    def meets_latest_delivery_date_with?(rate)
      rate.delivery_window_end <= latest_deliver_date
    end

    def latest_deliver_date
      @latest_deliver_date ||= begin
        delivery_time_adjuster.adjusted_date(ship_time, service_level.max_deliver_days)
      end
    end

    def delivery_time_adjuster
      TimeAdjuster.new(
        service_level.deliver_blackout_days.split(','),
        service_level.deliver_blackout_dates.split(',')
      )
    end

    def ship_time
      ShipTimeCalculator.new(
        Time.now,
        stock_location.same_day_cutoff_hour,
        stock_location.latest_daily_ship_hour,
        service_level.processing_days,
        stock_location.processing_blackout_days.split(','),
        stock_location.processing_blackout_dates.split(',')
      ).ship_time
    end

  end
end