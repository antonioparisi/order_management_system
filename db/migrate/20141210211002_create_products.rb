class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.float :net_price

      t.timestamps
    end

    add_index :products, :name, :unique => true
  end
end
