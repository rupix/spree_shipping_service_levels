require 'spec_helper'

module Spree::Shipping
  describe RatesBuilder do

    context '#shipping_rates' do
      it 'only includes one rate for each service level'
      it 'has the cheapest rate for each service level'
    end

  end
end