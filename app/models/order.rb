class Order < ActiveRecord::Base

  # Address information
  attr_accessible :address_one, :address_two, :city, :country, :number, :state, :zip, :phone
  validates :address_one, :city, :state, :zip, :name, :price, :user_id, :exp_month, :exp_year, presence: true
  
  # Shipping and billing information. Mostly moved to shipments...
  attr_accessible :stripe_id, :status, :shipping, :tracking_number, :expiration, :payment_option,
    :exp_month, :exp_year, :last4

  # Product information.
  attr_accessible :price, :name

  #Creates the unique id before creation for slug use
  attr_readonly :uuid
  before_validation :generate_uuid!, :on => :create

  belongs_to :user
  belongs_to :payment_option #we gonna use this? we should
  has_many :shipments, foreign_key: :order_id, primary_key: :id
  self.primary_key = :uuid
  
  #this adds a method Order::completed
  scope :completed, where("stripe_id != ? OR stripe_id != ?", "", nil)

  # After authenticating with Stripe
  def postfill!(customer)
    self.price      = customer.subscription.plan.amount / 100
    self.stripe_id  = customer.id
    self.exp_month  = customer.active_card.exp_month
    self.exp_year   = customer.active_card.exp_year
    self.last4      = customer.active_card.last4
    self.status     = "active"
    self.save!
    self
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

end
