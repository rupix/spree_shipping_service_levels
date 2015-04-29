require 'spec_helper'

describe Spree::Stock::Estimator, :type => :model do
  context "shipping_methods" do
    it 'should only show shipping methods that are offered at the package\'s stock location' do
      stock_location = Spree::StockLocation.create(name: 'sl1', country_id: 214)
      default_category = Spree::ShippingCategory.create(name: 'default')
      shipping_method_1 = create(:shipping_method, name: 'sm1', display_on: 'front_end')
      shipping_method_2 = create(:shipping_method, name: 'sm2', display_on: 'front_end')
      stock_location.shipping_methods << shipping_method_1
      package = build(:stock_package_with_contents, stock_location: stock_location)
      binding.pry
    end
  end
end