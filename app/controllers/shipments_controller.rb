class ShipmentsController < ApplicationController

	def index
		@order = Order.find(params[:order_id])
		@shipments = @order.shipments
	end

end
