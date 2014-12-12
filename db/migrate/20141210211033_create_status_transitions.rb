class CreateStatusTransitions < ActiveRecord::Migration
  def change
    create_table :status_transitions do |t|
      t.string :event
      t.string :from
      t.string :to
      t.references :order, :index => true

      t.timestamps
    end
  end
end
