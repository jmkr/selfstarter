class PreorderController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :ipn

  def index
  end

  def checkout

    if @user = current_user
      puts "current user?? #{@user.email}"
    end

  end

  def prefill

    # Get the current_user if one is already sign-in. If not, create a 
    # new user with the given parameters.
    if current_user
      @user = current_user
    elsif !params[:email].blank? && !params[:password].blank? && params[:password] == params[:passwordConfirm]
      @user  = User.find_or_create_by_email!(params[:email], :password => params[:password])
      sign_in @user, :bypass => true 
    else
      raise Exception.new("Please enter an email address and valid password")
    end

    if Settings.use_payment_options
      payment_option_id = params['payment_option']
      raise Exception.new("No payment option was selected") if payment_option_id.nil?
      payment_option = PaymentOption.find(payment_option_id)
      price = payment_option.amount
    else
      price = Settings.price
    end

    puts "name?? #{params[:name]}"
    puts "state?? #{params[:state ]}"


    # Validate the Shipping data from the form.
    if !params[:name].blank? && !params[:address1].blank? && !params[:city].blank? && !params[:state].blank? && !params[:zip].blank?
    else
      flash[:error] = "Please fill out all required fields"
      redirect_to preorder_checkout_path
      return
    end

    @order = Order.prefill!(
      :name => Settings.product_name, 
      :price => price, 
      :user_id => @user.id, 
      :payment_option => payment_option
    )

    # Get the credit card details submitted by the form
    token = params[:stripeToken]
    
    # Create a Customer object via Stripe.
    @customer = Stripe::Customer.create(
        :card => params[:stripeToken],
        :plan => "craftcrate-monthly",
        :email => @user.email
      )

    unless @customer.nil?
      Order.postfill!(@order.uuid, @customer)
    else
      redirect_to :action => :prefill, flash[:notice] => "Unable to authorize credit card"
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
