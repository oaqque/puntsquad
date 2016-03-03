class RemoveProfitOrLoss < ActiveRecord::Migration
  def change
    change_table :bets do |t|
      t.remove :profit_or_loss
    end
  end
end
