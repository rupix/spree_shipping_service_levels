require 'spec_helper'

module Spree::Shipping
  describe RatesBuilder do
    before(:each) do
      klass = RatesBuilder
      klass.send(:public, *klass.private_instance_methods)
    end
    let(:package){build(:stock_package_with_contents, stock_location: stock_locations[0])}
    let(:builder){build(:shipping_rates_builder, package: package)}
    let(:stock_locations){create_list(:stock_location_with_processing_info, 2)}
    let(:next_ship_time) do
      adjuster = TimeAdjuster.new(stock_locations[0].processing_blackout)
      adjuster.adjusted_date(Time.now.beginning_of_day + 13.hours, 1)
    end
    let(:ups_ground_calculator) do
      calc = Spree::ShippingCalculator.new
      allow(calc).to receive(:compute_package).and_return(5.6)
      delivery_window = DeliveryWindow.new(next_ship_time + 5.days, next_ship_time + 7.days)
      allow(calc).to receive(:estimate_delivery_window).and_return(delivery_window)
      allow(calc).to receive(:rate_daily_expiration_hour).and_return(12)
      calc
    end
    let(:express_mail_calculator) do
      calc = Spree::ShippingCalculator.new
      allow(calc).to receive(:compute_package).and_return(7.6)
      delivery_window = DeliveryWindow.new(next_ship_time + 1.days, next_ship_time + 3.days)
      allow(calc).to receive(:estimate_delivery_window).and_return(delivery_window)
      allow(calc).to receive(:rate_daily_expiration_hour).and_return(12)
      calc
    end
    let(:priority_mail_calculator) do
      calc = Spree::ShippingCalculator.new
      allow(calc).to receive(:compute_package).and_return(10.6)
      delivery_window = DeliveryWindow.new(next_ship_time + 1.days, next_ship_time + 1.days)
      allow(calc).to receive(:estimate_delivery_window).and_return(delivery_window)
      allow(calc).to receive(:rate_daily_expiration_hour).and_return(12)
      calc
    end
    let(:standard_calculator) do
      calc = Spree::ShippingCalculator.new
      allow(calc).to receive(:compute_package).and_return(8.6)
      delivery_window = DeliveryWindow.new(next_ship_time + 5.days, next_ship_time + 7.days)
      allow(calc).to receive(:estimate_delivery_window).and_return(delivery_window)
      allow(calc).to receive(:rate_daily_expiration_hour).and_return(11)
      calc
    end
    let(:priority_calculator) do
      calc = Spree::ShippingCalculator.new
      allow(calc).to receive(:compute_package).and_return(15.6)
      delivery_window = DeliveryWindow.new(next_ship_time + 1.days, next_ship_time + 1.days)
      allow(calc).to receive(:estimate_delivery_window).and_return(delivery_window)
      allow(calc).to receive(:rate_daily_expiration_hour).and_return(11)
      calc
    end
    let(:shipping_methods) do
      [
        create(:ups_ground_shipping_method, calculator: ups_ground_calculator),
        create(:express_mail_shipping_method, calculator: express_mail_calculator),
        create(:priority_mail_shipping_method, calculator: priority_mail_calculator),
        create(:standard_shipping_method, calculator: standard_calculator),
        create(:priority_shipping_method, calculator: priority_calculator)
      ]
    end
    let(:service_levels) do
      [
        create(:standard_shipping_service_level),
        create(:three_day_shipping_service_level),
        create(:two_day_shipping_service_level),
        create(:next_day_shipping_service_level)
      ]
    end
    before(:each) do
      stock_locations.each do |stock_location|
        service_levels.each do |service_level|
          stock_location.shipping_service_levels << service_level
        end
      end
      stock_locations[0].shipping_methods << shipping_methods[0]
      stock_locations[0].shipping_methods << shipping_methods[1]
      stock_locations[0].shipping_methods << shipping_methods[2]
      stock_locations[1].shipping_methods << shipping_methods[3]
      stock_locations[1].shipping_methods << shipping_methods[4]
      package.order.ship_address = package.order.bill_address
      package.order.save!
    end
    context '#shipping_rates' do
      let(:rates){builder.shipping_rates}
      it 'only includes at most one rate for each service level' do
        expect(rates.length).to be <= 4
        assigned_service_levels = rates.map(&:shipping_service_level)
        expect(assigned_service_levels.uniq.length).to eq(assigned_service_levels.length)
      end
      it 'has the cheapest rate for each service level' do
        rates.each do |rate|
          service_level = rate.shipping_service_level
          cheapest_rate = builder.rates_for_service_level(service_level).min{|a,b|a.cost <=> b.cost}
          expect(rate.cost).to eq(cheapest_rate.cost)
        end
      end
      it 'only has rates for the service levels of the package\'s stock location' do
        rates.each do |rate|
          expect(stock_locations[0].shipping_service_levels).to include(rate.shipping_service_level)
        end
      end
      it 'only includes rates that meet the requirements of the stock location\'s service levels' do
        rates.each do |rate|
          ship_time_calculator = ShipTimeCalculator.new(
            Time.now, 
            stock_locations[0].same_day_cutoff_hour,
            stock_locations[0].latest_daily_ship_hour,
            rate.shipping_service_level.processing_days,
            stock_locations[0].processing_blackout
          )
          ship_time = ship_time_calculator.ship_time
          rate_tester = ServiceLevelRateTester.new(rate.shipping_service_level, ship_time)
          expect(rate_tester.passes_with?(rate)).to eq(true)
        end
      end
      it 'only includes rates for shipping methods on the package\'s stock location' do
        rates.each do |rate|
          expect(package.stock_location.shipping_methods).to include(rate.shipping_method)
        end
      end
      it 'only includes rates with shipping methods that can ship the package' do
        rates.each do |rate|
          expect(rate.shipping_method.can_ship?(package)).to eq(true)
        end
      end
      it 'includes no two rates with the same shipping method' do
        assigned_methods = rates.map(&:shipping_method)
        expect(assigned_methods.uniq.length).to eq(assigned_methods.length)
      end
    end

  end
end