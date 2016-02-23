class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.string :game
      t.string :units_placed
      t.string :odds
      t.string :profit_or_loss

      t.timestamps null: false
    end
  end
end
