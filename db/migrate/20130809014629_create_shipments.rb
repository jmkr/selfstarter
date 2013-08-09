class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.integer :order_id
      t.datetime :date
      t.decimal :total
      t.string :method
      t.string :tracking

      t.timestamps
    end
  end
end
