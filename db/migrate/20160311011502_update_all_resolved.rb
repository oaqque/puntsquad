class UpdateAllResolved < ActiveRecord::Migration
  def change
    Bet.update_all(resolved: true)
  end
end
