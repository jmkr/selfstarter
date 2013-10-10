class CreateDiys < ActiveRecord::Migration
  def change
    create_table :diys do |t|
    	t.string :title
    	t.string :image
    	t.text :body

      t.timestamps
    end
  end
end
