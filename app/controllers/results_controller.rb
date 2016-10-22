class ResultsController < ApplicationController

  def index

    #ARCHIVING
    @archive_by_month = Bet.all.order("date_of_bet DESC")
    @archive_by_month = @archive_by_month.group_by { |bet| bet.date_of_bet.beginning_of_month }
    @archive_by_sport = Bet.all.group_by { |bet| bet.sport }

    @total = 0
    @bets = Bet.where("sport != ?", 8)

    @bets.each do |x|
      if x.profit_or_loss > -100 && x.profit_or_loss < 100
        @total += x.profit_or_loss
      end
    end

    @sum = 0 #for graph

    #This Year
    @year_start = Date.new(2016, 1, 1)
    @year_end = Date.new(2016, 12, 31)

    #Units Outlayed
    @total_units = @bets.sum(:units_placed)
    @units_returned = @total + @total_units
    @return_on_investment = (@total / @total_units * 100).round(2)
  end

  def admin
    @bets = Bet.all
    @bets = @bets.order("date_of_bet DESC")

    @latest_bets = @bets.order('date_of_bet DESC').paginate(:page => params[:page], per_page: 150).order("resolved ASC, date_of_bet DESC, game ASC, updated_at ASC")
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

    #Units Outlayed
    @total_units = @bets_by_month.sum(:units_placed)
    @units_returned = @monthly_total + @total_units
    @return_on_investment = (@monthly_total / @total_units * 100).round(2)

    #Group Categories
    @bets_by_day = @bets_by_month.all.group_by { |bet| bet.date_of_bet.beginning_of_day }
    @bets_by_month = @bets_by_month.all.group_by { |bet| bet.date_of_bet.beginning_of_month }

    #ARCHIVE
    @archive_by_month = Bet.all.order("date_of_bet DESC")
    @archive_by_month = @archive_by_month.group_by { |bet| bet.date_of_bet.beginning_of_month }
    @archive_by_sport = Bet.all.group_by { |bet| bet.sport }


  end

  def by_year_and_month_and_day


    @bets_by_year = Bet.where("EXTRACT(YEAR FROM date_of_bet) = ?", params[:year])
    @bets_by_month = @bets_by_year.where("EXTRACT(MONTH FROM date_of_bet) = ?", params[:month])
    @bets_by_day = @bets_by_month.where("EXTRACT(DAY FROM date_of_bet) = ?", params[:day])
    @bets_by_day = @bets_by_day.order("resolved ASC, date_of_bet DESC, sport ASC, game ASC")

    @totals = 0

    @bets_by_day.each do |x|
      if x.profit_or_loss > -100 && x.profit_or_loss < 100
        @totals += x.profit_or_loss
      end
    end

    #Grab Bet's from Today
    @bets_by_day = @bets_by_day.paginate(:page => params[:page], per_page: 50)

    #Find Today's Date
    @today = @bets_by_day.first.date_of_bet

    #ARCHIVE
    @archive_by_month = Bet.all.order("date_of_bet DESC")
    @archive_by_month = @archive_by_month.group_by { |bet| bet.date_of_bet.beginning_of_month }
    @archive_by_sport = Bet.all.group_by { |bet| bet.sport }


  end

  def by_sport

    #Grab the Bet containing the sport
    @bets_by_sport = Bet.where("sport = ?", params[:sport])
    @sport = params[:sport].to_i

    #Display the Unit Stats at top
    @sport_total = 0
    @bets_by_sport.each do |x|
      if x.profit_or_loss > -100 && x.profit_or_loss < 100
        @sport_total += x.profit_or_loss
      end
    end

    @total_units = @bets_by_sport.sum(:units_placed)
    @units_returned = @total_units + @sport_total
    @return_on_investment = (@sport_total / @total_units * 100).round(2)

    #ARCHIVE
    @archive_by_month = Bet.all.order("date_of_bet DESC")
    @archive_by_month = @archive_by_month.group_by { |bet| bet.date_of_bet.beginning_of_month }
    @archive_by_sport = Bet.all.group_by { |bet| bet.sport }

    #graph
    @sum = 0

    #Listing Last 10 bets_by_sport
    @latest_bets = @bets_by_sport.order('date_of_bet DESC').paginate(:page => params[:page], per_page: 100).order("resolved ASC, date_of_bet DESC, game ASC, updated_at ASC")

  end
end
