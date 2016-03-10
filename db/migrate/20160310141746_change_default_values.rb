class ChangeDefaultValues < ActiveRecord::Migration
  def change
    change_column_default :bets, :date_of_bet, Date.today
  end
end
