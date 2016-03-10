class ResultsController < ApplicationController

  def index
    @archive = Bet.all.group_by { |bet| bet.date_of_bet.beginning_of_month }
    @total = 0
    @bets = Bet.all

    @bets.each do |x|
      @total += x.profit_or_loss
    end

  end

  def by_year_and_month
    #Generate All Categories
    @bets_by_year = Bet.where("EXTRACT(YEAR FROM date_of_bet) = ?", params[:year])
    @bets_by_month = @bets_by_year.where("EXTRACT(MONTH FROM date_of_bet) = ?", params[:month])
    @bets_by_month = @bets_by_month.order("date_of_bet DESC")

    #Totals
    @monthly_total = 0

    @bets_by_month.each do |x|
      @monthly_total += x.profit_or_loss
    end

    #Group Categories
    @bets_by_day = @bets_by_month.all.group_by { |bet| bet.date_of_bet.beginning_of_day }
    @bets_by_month = @bets_by_month.all.group_by { |bet| bet.date_of_bet.beginning_of_month }

    @archive = Bet.all.group_by { |bet| bet.date_of_bet.beginning_of_month }


  end

  def by_year_and_month_and_day
    @archive = Bet.all.group_by { |bet| bet.date_of_bet.beginning_of_month }

    @bets_by_year = Bet.where("EXTRACT(YEAR FROM date_of_bet) = ?", params[:year])
    @bets_by_month = @bets_by_year.where("EXTRACT(MONTH FROM date_of_bet) = ?", params[:month])
    @bets_by_day = @bets_by_month.where("EXTRACT(DAY FROM date_of_bet) = ?", params[:day])
    @bets_by_day = @bets_by_day.order("date_of_bet DESC")

    @totals = 0

    @bets_by_day.each do |x|
      @totals += x.profit_or_loss
    end


    @bets_by_day = @bets_by_day.all.group_by { |bet| bet.date_of_bet.beginning_of_day }

  end
end
