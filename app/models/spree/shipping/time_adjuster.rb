module Spree::Shipping
  class TimeAdjuster

    def initialize(blackout_days, blackout_dates)
      @blackout_days = blackout_days
      @blackout_dates = blackout_dates
    end

    def adjusted_date(start, days)
      start + days_to_adjusted_date(start, days).days
    end

    def days_to_adjusted_date(start, days)
      days_adjusted_for_blackouts(start, days)
    end

    def date_blacked_out?(day)
      dates_contain(blackout_dates, day) || 
      days_contain(blackout_days, day)
    end

    private

    attr_reader :blackout_days, :blackout_dates

    def dates_contain(dates, test_date)
      matches = dates.select do |date|
        date_parts = date.split('/')
        month = date_parts[0].to_i
        day = date_parts[1].to_i
        test_date.month == month && test_date.day == day
      end
      matches.any?
    end

    def days_contain(days, test_date)
      days.include?(test_date.wday.to_s)
    end

    def days_adjusted_for_blackouts(start, days)
      valid_days = 0
      adjusted_days = 0
      current_date = start
      while valid_days < days
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