class ChangeColumnProfitOrLossDefault < ActiveRecord::Migration
  def change
    change_column_default :bets, :profit_or_loss, -999
  end
end
