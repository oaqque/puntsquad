class AddProfitOrLoss < ActiveRecord::Migration
  def change
    change_table :bets do |t|
      t.decimal :profit_or_loss
    end
  end
end
