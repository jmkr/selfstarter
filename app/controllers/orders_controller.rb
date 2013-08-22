class OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :ipn

  def index
    @orders = current_user.orders
    render :index
  end

  def new
    @order = Order.new
  end

  def create
    # Redirect to Sign In if current user doesn't exist. 
    # Need to keep track of Address/Card info they entered then redirect back to here *after* they login.
    unless current_user.nil?
      @order = current_user.orders.new(params[:order])
      @order.price = Settings.price

      # Create a Customer object via Stripe.
      customer = Stripe::Customer.create(
          :card => params[:stripeToken],
          :plan => "craftcrate-monthly",
          :email => current_user.email
        )

      if customer
        @order.postfill!(customer)
        render :share
      else
        redirect_to :action => :create, flash[:notice] => "Unable to authorize credit card"
      end
    else
      redirect_to user_session_path
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_url   
  end

  # Cancel's a user's subscription with the given Stripe customer id. Shows a flash upon success or failure.
  def cancel
    if @order = Order.find(params[:id])
      cu = Stripe::Customer.retrieve(@order.stripe_id)
      if success = cu.cancel_subscription
        if success.status == "canceled"
          @order.update_attributes(status: "canceled")
          flash[:success] = "Subscription successfully canceled."
          redirect_to :action => :index
        end
      end
    else
      flash[:error] = "Unable to cancel order."
      redirect_to :action => :index
    end
  rescue Stripe::InvalidRequestError => e
    flash[:error] = "Error cancelling order."
    redirect_to :action => :index
  end
end
