class EmailListsController < ApplicationController

	def create
		@email = EmailList.new(params[:email_list])

		if @email.save
			flash[:success] = "#{@email.email} is a sweet email ;-)"
		else
			flash[:error] = "That email has been submitted already!"
		end

		redirect_to root_url
	end
end