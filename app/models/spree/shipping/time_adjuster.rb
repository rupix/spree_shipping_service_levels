module Spree::Shipping
  class TimeAdjuster

    def initialize(blackout)
      @blackout = blackout
    end

    def adjusted_date(start, days)
      start + days_to_adjusted_date(start, days).days
    end

    def days_to_adjusted_date(start, days)
      days_adjusted_for_blackouts(start, days)
    end

    def date_blacked_out?(day)
      blackout.date_blacked_out?(day)
    end

    private

    attr_reader :blackout

    def days_adjusted_for_blackouts(start, days)
      valid_days = 0
      adjusted_days = 0
      current_date = start.clone
      while valid_days < days || date_blacked_out?(current_date)
        current_date += 1.day 
        adjusted_days += 1
        if !date_blacked_out?(current_date)
          valid_days += 1
        end
      end
      adjusted_days
    end

  end
end