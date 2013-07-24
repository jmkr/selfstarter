class UsersController < ApplicationController
  before_filter :user_signed_in?, only: [:settings, :orders]

  def settings
    if @user = current_user
      
    end
  end

  def orders
    # if current_user.nil?
    #   # Redirect to sign in page.
        
    # else
      @orders = current_user.orders
      # @user.orders.each do |order|
      #   puts "ORDER: #{order.inspect}"
      # end
    # end
    render :orders
  end
end
