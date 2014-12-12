class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :order, :index => true
      t.references :product, :index => true
      t.integer :quantity, :null => false
      t.decimal :net_price, :null => false

      t.timestamps
    end
  end
end
