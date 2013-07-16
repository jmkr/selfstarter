class Order < ActiveRecord::Base
  # Address information
  attr_accessible :address_one, :address_two, :city, :country, :number, :state, :zip, :phone

  # Shipping and billing information.
  attr_accessible :stripe_id, :status, :shipping, :tracking_number, :expiration, :payment_option,
    :exp_month, :exp_year, :last4

  # Product information.
  attr_accessible :price, :name

  attr_readonly :uuid
  before_validation :generate_uuid!, :on => :create
  belongs_to :user
  belongs_to :payment_option
  scope :completed, where("stripe_id != ? OR stripe_id != ?", "", nil)
  self.primary_key = 'uuid'

  # Prefill some order information before authenticating with Stripe.
  def self.prefill!(options = {})
    @order                = Order.new
    @order.name           = options[:name]
    @order.user_id        = options[:user_id]
    @order.price          = options[:price]
    @order.number         = Order.next_order_number
    @order.payment_option = options[:payment_option] if !options[:payment_option].nil?
    @order.address_one    = options[:line1]
    @order.address_two    = options[:line2]
    @order.city           = options[:city]
    @order.state          = options[:state]
    @order.zip            = options[:zip]
    @order.phone          = options[:phone]
    @order.country        = options[:country]
    @order.save!

    @order
  end

  # After authenticating with Stripe, store the exp month and year and last CC digits.
  def self.postfill!(uuid, customer)

    @order = Order.find_by_uuid!(uuid)
    if @order.stripe_id.present?
      @order.stripe_id         = customer.id
      @order.exp_month       = customer[:active_card][:exp_month]
      @order.exp_year        = customer[:active_card][:exp_year]
      @order.last4           = customer[:active_card][:last4]
      @order.save!
      @order
    end
  end

  def self.next_order_number
    if Order.count > 0
      Order.order("number DESC").limit(1).first.number.to_i + 1
    else
      1
    end
  end

  def generate_uuid!
    begin
      self.uuid = SecureRandom.hex(16)
    end while Order.find_by_uuid(self.uuid).present?
  end

  # goal is a dollar amount, not a number of backers, beause you may be using the multiple payment options component
  # by setting Settings.use_payment_options == true
  def self.goal
    Settings.project_goal
  end

  def self.percent
    (Order.revenue.to_f / Order.goal.to_f) * 100.to_f
  end

  # See what it looks like when you have some backers! Drop in a number instead of Order.count
  def self.backers
    Order.completed.count
  end

  def self.revenue
    if Settings.use_payment_options
      PaymentOption.joins(:orders).where("token != ? OR token != ?", "", nil).pluck('sum(amount)')[0].to_f
    else
      Order.completed.sum(:price).to_f
    end 
  end

  validates_presence_of :name, :price, :user_id
end
