class ResultsController < ApplicationController

  def index
    @archive = Bet.all.group_by { |bet| bet.date_of_bet.beginning_of_month }
    @total = 0
    @bets = Bet.all

    @bets.each do |x|
      if x.profit_or_loss > -100 && x.profit_or_loss < 100
        @total += x.profit_or_loss
      end
    end

    @sum = 0 #for graph
  end

  def admin
    @bets = Bet.all
    @bets = @bets.order("date_of_bet DESC")
  end

  def by_year_and_month
    #Generate All Categories
    @bets_by_year = Bet.where("EXTRACT(YEAR FROM date_of_bet) = ?", params[:year])
    @bets_by_month = @bets_by_year.where("EXTRACT(MONTH FROM date_of_bet) = ?", params[:month])
    @this_month_bets = @bets_by_month
    @bets_by_month = @bets_by_month.order("date_of_bet DESC")
    @sum = 0

    #This Month
    @year = params[:year].to_i
    @month = params[:month].to_i

    @month_start = Date.new(@year, @month, 1)

    if @month == 1 || @month == 3 || @month == 5 || @month == 7 || @month == 8 || @month == 10 || @month == 12
      @month_end = Date.new(@year, @month, 31)
    elsif @month == 2 && @year%4 == 0
      @month_end = Date.new(@year, @month, 29)
    elsif @month == 2 && @year%4 != 0
      @month_end = Date.new(@year, @month, 28)
    elsif @month == 4 || @month == 6 || @month == 9 || @month == 11
      @month_end = Date.new(@year, @month, 30)
    end

    #Totals
    @monthly_total = 0

    @bets_by_month.each do |x|
      if x.profit_or_loss > -100 && x.profit_or_loss < 100
        @monthly_total += x.profit_or_loss
      end
    end

    #Group Categories
    @bets_by_day = @bets_by_month.all.group_by { |bet| bet.date_of_bet.beginning_of_day }
    @bets_by_month = @bets_by_month.all.group_by { |bet| bet.date_of_bet.beginning_of_month }

    #archive
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
      if x.profit_or_loss > -100 && x.profit_or_loss < 100
        @totals += x.profit_or_loss
      end
    end


    @bets_by_day = @bets_by_day.all.group_by { |bet| bet.date_of_bet.beginning_of_day }

  end
end
