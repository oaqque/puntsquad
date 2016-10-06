class CreateMeets < ActiveRecord::Migration
  def change
    create_table :meets do |t|
      t.string :name
    end
  end
end
