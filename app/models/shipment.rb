class Shipment < ActiveRecord::Base
  attr_accessible :date, :method, :order_id, :total, :tracking

  validates :date, :order_id, :method, presence: true


  belongs_to :order

  ## Method for the admin to run to prep the monthly shipments
  # Add a button to rails admin to run monthly or run on a date?

  def self.create_monthly_shipments
    shipments_not_created_for = []
    current_date = Time.new(Time.now.year, Time.now.month)

  	Order.all.each do |order|

  		exp_date = Time.new(order.exp_year, order.exp_month)
      if order.canceled_at
        exp_date = Time.new(canceled_at.year, canceled_at.month, canceled_at.day)
      end

      repeat = false
      order.shipments.each do |shipment|
        if shipment.date == current_date
          puts "ERROR: A shipment for order #{order.id} has already been created this month."
          repeat = true
        end
      end

  		if exp_date >= current_date && !repeat
				new_shipment = order.shipments.build(  date: current_date,
																      method: "ground",
                											total: order.price)
        if new_shipment.save!
          puts "shipment created for #{order}"
        else
          shipments_not_created_for << order.id
          puts new_shipment.errors.full_messages
        end
  		end
  	end
    puts "Shipments not created for the following order ids"
    shipments_not_created_for
  end

  def self.create_single_shipment(order)
    current_date = Time.new(Time.now.year, Time.now.month)
    exp_date = Time.new(order.exp_year, order.exp_month)
    if order.canceled_at
      exp_date = Time.new(canceled_at.year, canceled_at.month, canceled_at.day)
    end

    repeat = false
    order.shipments.each do |shipment|
      if shipment.date == current_date
        puts "A shipment for order #{order.id} has been created this month."
        repeat = true
      end
    end

    if exp_date >= current_date && !repeat
      new_shipment = order.shipments.build(  date: current_date,
                                    method: "ground",
                                    total: order.price)
      if new_shipment.save!
        puts "shipment created for #{order}"
      else
        new_shipment.errors.full_messages.each do |message|
          puts message
        end
      end
    end

  end

end
