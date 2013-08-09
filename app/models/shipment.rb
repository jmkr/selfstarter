class Shipment < ActiveRecord::Base
  attr_accessible :date, :method, :order_id, :total, :tracking

  validates :date, :order_id, :method, presence: true

  belongs_to :order


  ## Method for the admin to run to prep the monthly shipments
  	# May want to add a fail safe
  	# Only create a shipment if no shipments for that order in this month
  	# Fail safe if create! errors? Use .new and .save! instead

  def self.create_monthly_shipments
  	Order.all.each do |order|
  		current_date = Time.new(Time.now.year, Time.now.month)
  		#month might act up if it is in the DB as ex. '08' for Aug
  		order_date = Time.new(order.exp_year, order.exp_month)
  		
  		if exp_date >= current_date
				order.shipments.create!(date: Time.now,
																method: "ground",
																total: order.price)
  		end
  	end
  end

end
