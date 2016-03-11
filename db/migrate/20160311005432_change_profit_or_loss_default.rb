class ChangeProfitOrLossDefault < ActiveRecord::Migration
  def change
    change_column_default :bets, :profit_or_loss, 0
  end
end
