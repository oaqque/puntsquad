class HomeController < ApplicationController
  def index
    @weekly_plan = Plan.find(4)
    @monthly_plan = Plan.find(5)
    @yearly_plan = Plan.find(6)

    #Locate Today's Bets
    @today_bets = Bet.where("date_of_bet = ?", Date.today)

    #Target This Month's Bets
    @bets_by_year = Bet.where("EXTRACT(YEAR FROM date_of_bet) = ?", Time.now.year)
    @bets_by_month = @bets_by_year.where("EXTRACT(MONTH FROM date_of_bet) = ?", Time.now.month)
    @bets_by_month = @bets_by_month.order("date_of_bet DESC")

    #Monthly Total
    @monthly_total = 0
    @bets_by_month.each do |x|
      @monthly_total += x.profit_or_loss
    end

  end
end
