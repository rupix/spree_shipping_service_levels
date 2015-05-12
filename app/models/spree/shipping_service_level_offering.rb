module Spree
	class ShippingServiceLevelOffering < ActiveRecord::Base
		belongs_to :stock_location
		belongs_to :shipping_service_level
	end
end