class UsersController < ApplicationController
  def settings
    if @user = current_user
      
    end
  end

  def orders
    if @user = current_user
      @orders = @user.orders
      @user.orders.each do |order|
        puts "ORDER: #{order.inspect}"
      end
    end
  end
end
