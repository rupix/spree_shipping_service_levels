module Spree
	class ShippingMethodOffering < ActiveRecord::Base
		belongs_to :stock_location
		belongs_to :shipping_method
	end
end