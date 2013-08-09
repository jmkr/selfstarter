class ShipmentsController < ApplicationController

	def index
		@shipments = Shipment.where(order_id: params[:order_id])
	end

end
