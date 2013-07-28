class OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :ipn

  def index
    @orders = current_user.orders
    render :index
  end

  def new
  end

  def create
 
    #why is name in the order the current_user's name?
    #params[:order][:name] = Settings.product_name
    params[:order][:price] = Settings.price
    @order = current_user.orders.new(params[:order])
    
    unless @order.save
      redirect_to :action => :prefill, flash[:notice] => "Unable to save order"
    end

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
      redirect_to :action => :prefill, flash[:notice] => "Unable to authorize credit card"
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_url    
  end

  # def share
  #   #does anyone ever go directly to share?... this is never used
  #   @order = Order.find_by_uuid(params[:uuid])
  # end

  def cancel
    #hit stripe to cancel the billing
    #update our db
    redirect_to root_url
  end
end
