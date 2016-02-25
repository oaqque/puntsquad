class ResultsController < ApplicationController
  def index
    @bets_by_month = Bet.all.group_by { |bet| bet.created_at.beginning_of_month }
  end

  def by_year_and_month
    @bets_by_year = Bet.where("date_part(year FROM created_at) = ?", params[:year])
    @bets_by_month = @bets_by_year.where("date_part(month FROM created_at) = ?", params[:month])
    @bets_by_month = @bets_by_month.all.group_by { |bet| bet.created_at.beginning_of_month }
  end
end
