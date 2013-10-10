class DiysController < ApplicationController

	def index
		@diys = Diy.all
	end

	def show
		@diy = Diy.find(params[:id])
	end

end
