class AddColumnPushAndUnresolved < ActiveRecord::Migration
  def change
    add_column :bets, :push, :boolean
    add_column :bets, :resolved, :boolean
    change_column_default :bets, :push, false
    change_column_default :bets, :resolved, false
  end
end
