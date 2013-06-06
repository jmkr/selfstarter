class PreorderController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :ipn

  def index
  end

  def checkout
  end

  def prefill

    unless params[:email].blank?
      @user  = User.find_or_create_by_email!(params[:email])
    else
      raise Exception.new("Please enter an email address")
    end

    if Settings.use_payment_options
      payment_option_id = params['payment_option']
      raise Exception.new("No payment option was selected") if payment_option_id.nil?
      payment_option = PaymentOption.find(payment_option_id)
      price = payment_option.amount
    else
      price = Settings.price
    end

    @order = Order.prefill!(:name => Settings.product_name, :price => price, :user_id => @user.id, :payment_option => payment_option)

    # Get the credit card details submitted by the form
    token = params[:stripeToken]
    
    # Create a Customer
    @customer = Stripe::Customer.create(
        :card => params[:stripeToken],
        :plan => "craftcrate-monthly",
        :email => @user.email
      )

    unless @customer.nil?
      @order = Order.postfill!(@order.uuid, @customer)
    end

    if @customer.present?
      redirect_to :action => :share, :uuid => @order.uuid
    else
      redirect_to root_url
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_url    
  end

  def share
    @order = Order.find_by_uuid(params[:uuid])
  end

  def ipn
  end
end
