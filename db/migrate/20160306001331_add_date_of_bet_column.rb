class AddDateOfBetColumn < ActiveRecord::Migration
  def change
    add_column :bets, :date_of_bet, :date
  end
end
