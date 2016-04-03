class HomeController < ApplicationController

  def index
    #Locate Today's Bets
    @today_bets = Bet.where("resolved = ?", false).order("date_of_bet ASC").order("sport DESC").order("game DESC")

    #Target This Month's Bets
    @bets_by_year = Bet.where("EXTRACT(YEAR FROM date_of_bet) = ?", Time.now.year)
    @bets_by_month = @bets_by_year.where("EXTRACT(MONTH FROM date_of_bet) = ?", Time.now.month)
    @bets_by_month = @bets_by_month.order("date_of_bet DESC")


    #Monthly Total
    @monthly_total = 0
    @bets_by_month.each do |x|
      if x.profit_or_loss > -100 && x.profit_or_loss < 100
        @monthly_total += x.profit_or_loss
      end
    end

  end

  def betting_guide
  end

end
