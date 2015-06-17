module Spree::Shipping
  class Blackout

    def self.from_strings(weekdays_string, dates_string)
      new(weekdays_string.split(','), dates_string.split(','))
    end

    def initialize(weekdays, dates)
      @weekdays = weekdays
      @dates = dates
    end

    def date_blacked_out?(day)
      @tested_dates ||= {}
      @tested_dates[day.strftime("%Y%m%d")] ||= begin
        dates_contain(day) || 
        weekdays_contain(day)
      end
    end

    attr_reader :weekdays, :dates

    private

    def dates_contain(test_date)
      matches = dates.select do |date|
        date_parts = date.split('/')
        month = date_parts[0].to_i
        day = date_parts[1].to_i
        test_date.month == month && test_date.day == day
      end
      matches.any?
    end

    def weekdays_contain(test_date)
      weekdays.include?(test_date.wday.to_s)
    end
  end
end