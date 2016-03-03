class ChangeProfitOrLoss < ActiveRecord::Migration
  def change
    change_column :bets, :profit_or_loss, :decimal
  end
end
