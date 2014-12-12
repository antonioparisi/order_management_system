class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.string :reason
      t.datetime :order_date, :default => Date.today.to_time
      t.float :vat, :default => 0.20

      t.timestamps
    end
  end
end
