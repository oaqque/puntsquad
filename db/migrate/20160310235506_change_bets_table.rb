class ChangeBetsTable < ActiveRecord::Migration
  def change
    remove_column :bets, :odds
    remove_column :bets, :units_placed
    add_column :bets, :odds, :decimal
    add_column :bets, :units_placed, :decimal
    change_column_default :bets, :odds, 0
    change_column_default :bets, :units_placed, 0
  end
end
