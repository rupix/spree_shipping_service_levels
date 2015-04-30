require 'spec_helper'
track_inventory = Spree::Config[:track_inventory_levels]
describe Spree::Stock::Estimator, :type => :model do

  context "shipping_methods" do
    before do
      Spree::Config[:track_inventory_levels] = false
    end
    after do
      Spree::Config[:track_inventory_levels] = track_inventory
    end
    it 'should only show shipping methods that are offered at the package\'s stock location' do
      stock_location = Spree::StockLocation.create(name: 'sl1', country_id: 214)
      default_category = Spree::ShippingCategory.create(name: 'default')
      shipping_method_1 = create(:shipping_method, name: 'sm1', display_on: 'front_end')
      shipping_method_2 = create(:shipping_method, name: 'sm2', display_on: 'front_end')
      stock_location.shipping_methods << shipping_method_1
      package = build(:stock_package_with_contents, stock_location: stock_location)
      estimator = Spree::Stock::Estimator.new(package.order)
      expect(estimator.shipping_methods(package, Spree::ShippingMethod::DISPLAY_ON_FRONT_END)).to eq [shipping_method_1]
    end
  end
  
end