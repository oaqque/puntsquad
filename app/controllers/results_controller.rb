class ResultsController < ApplicationController
  def index
    @archive = Bet.all.group_by { |bet| bet.created_at.beginning_of_month }
  end

  def by_year_and_month
    @bets_by_year = Bet.where("EXTRACT(YEAR FROM created_at) = ?", params[:year])
    @bets_by_month = @bets_by_year.where("EXTRACT(MONTH FROM created_at) = ?", params[:month])
    @bets_by_month = @bets_by_month.order("created_at DESC")
    @bets_by_day = @bets_by_month.all.group_by { |bet| bet.created_at.beginning_of_day }
    @bets_by_month = @bets_by_month.all.group_by { |bet| bet.created_at.beginning_of_month }

    @total = 0
    @bets_by_month.each do |month, bets|
      for bet in bets do
        @total += bets.profit_or_loss
      end  
    end

    @archive = Bet.all.group_by { |bet| bet.created_at.beginning_of_month }
  end

  def by_year_and_month_and_day
    @archive = Bet.all.group_by { |bet| bet.created_at.beginning_of_month }

    @bets_by_year = Bet.where("EXTRACT(YEAR FROM created_at) = ?", params[:year])
    @bets_by_month = @bets_by_year.where("EXTRACT(MONTH FROM created_at) = ?", params[:month])
    @bets_by_day = @bets_by_month.where("EXTRACT(DAY FROM created_at) = ?", params[:day])
    @bets_by_day = @bets_by_day.order("created_at DESC")

    @bets_by_day = @bets_by_day.all.group_by { |bet| bet.created_at.beginning_of_day }

  end
end
