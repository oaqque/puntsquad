class AddBookmakerAndSport < ActiveRecord::Migration
  def change
    add_column :bets, :bookmaker, :integer
    add_column :bets, :sport, :integer
  end
end
