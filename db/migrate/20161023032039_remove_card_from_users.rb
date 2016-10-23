class RemoveCardFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :stripeid, :string
    remove_column :users, :stripe_subscription_id, :string
    remove_column :users, :card_last4, :string
    remove_column :users, :card_exp_month, :integer
    remove_column :users, :card_exp_year, :integer
    remove_column :users, :card_type, :string
    remove_column :users, :package, :string
  end
end
