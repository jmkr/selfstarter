class Shipment < ActiveRecord::Base
  attr_accessible :date, :method, :order_id, :total, :tracking

  validates :date, :order_id, :method, presence: true


  belongs_to :order


  ## Method for the admin to run to prep the monthly shipments

  def self.create_monthly_shipments
  	Order.all.each do |order|
  		current_date = Time.new(Time.now.year, Time.now.month)
  		order_date = Time.new(order.exp_year, order.exp_month)
      repeat = false

      order.shipments.each do |shipment|
        if shipment.date == current_date
          repeat = true
        end
      end

  		if exp_date >= current_date && !repeat
				new_shipment = order.shipments.create!(date: current_date,
																                method: "ground",
                																total: order.price)
        if new_shipment.save!
          puts "shipment created for #{order}"
        else
          puts "there was an error creating a shipment for #{order}"
        end
  		end

  	end
  end
end
