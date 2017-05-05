class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :price
      t.boolean :recurring
      t.string :period
      t.integer :cycles
      t.integer :duration
      t.integer :plan_id
      t.timestamps
    end
  end
end
