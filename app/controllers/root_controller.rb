class RootController < ApplicationController

	def index
		@email = EmailList.new
	end
	
end
