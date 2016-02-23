class AddBetToBets < ActiveRecord::Migration
  def change
    add_column :bets, :bet_placed, :string
  end
end
