module Spree::Shipping
  class ShipTimeCalculator

    def initialize(
      order_time, 
      same_day_cutoff_hour, 
      latest_daily_ship_hour, 
      processing_days, 
      blackout
    )
      @order_time = order_time
      @same_day_cutoff_hour = same_day_cutoff_hour
      @latest_daily_ship_hour = latest_daily_ship_hour
      @processing_days = processing_days
      @adjuster = TimeAdjuster.new(blackout)
    end

    def ship_time
      order_time.beginning_of_day + days_to_ship.days + latest_daily_ship_hour.hours
    end

    private

    attr_reader( 
      :order_time,
      :same_day_cutoff_hour, 
      :latest_daily_ship_hour, 
      :processing_days,
      :adjuster
    )

    def days_to_ship
      processing_days = @processing_days
      if after_same_day_cutoff? && !order_date_blacked_out?
        processing_days += 1
      end
      adjuster.days_to_adjusted_date(order_time, processing_days)
    end

    def after_same_day_cutoff?
      order_time > order_time.beginning_of_day + same_day_cutoff_hour.hours
    end

    def order_date_blacked_out?
      adjuster.date_blacked_out?(order_time)
    end 

  end
end