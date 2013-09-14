class ChangeColumnInShipment < ActiveRecord::Migration
  def change
  	change_column :shipments, :order_id, :string
  end
end
