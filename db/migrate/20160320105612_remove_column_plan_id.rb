class RemoveColumnPlanId < ActiveRecord::Migration
  def change
    remove_column :users, :plan_id
    remove_column :users, :stripe_customer_token
  end
end
