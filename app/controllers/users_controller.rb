class UsersController < ApplicationController
  before_filter :user_signed_in?, only: [:settings, :orders]

  def settings
  end

  def orders
    @orders = current_user.orders
    render :orders
  end
end
