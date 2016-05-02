class HomeController < ApplicationController

  def index
    #Locate Today's Bets
    @today_bets = Bet.where("resolved = ? AND sport != ?", false, 7).order("date_of_bet ASC").order("sport ASC").order("game ASC")
    @today_horse_bets = Bet.where("resolved = ? AND sport = ?", false, 7).order("date_of_bet ASC").order("sport ASC").order("game ASC")

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

  def analysis
    #Grab all the bets
    @bets = Bet.all

    #Separate the bets into odds less than 3
    #Separate the bets into odds between 3 and 7
    #Separate the bets into odds larger than 7
    @horse_under_3 = @bets.where("sport = ? AND odds < ?", 7, 3)
    @horse_between_3_and_7 = @bets.where("sport = ? AND odds <= ? AND odds >= ?", 7, 7, 3)
    @horse_over_7 = @bets.where("sport = ? AND odds > ?", 7, 7)

    #Find total staked on odds less than 3
    #Find PnL for odds less than 3
    @hu3_total_staked = 0
    @hu3_pnl = 0
    for bet in @horse_under_3
      @hu3_total_staked += bet.units_placed
      @hu3_pnl += bet.profit_or_loss
    end

    #Find total staked on odds between 3 and 7
    #Find PnL for odds between 3 and 7
    @h3to7_total_staked = 0
    @h3to7_pnl = 0
    for bet in @horse_between_3_and_7
      @h3to7_total_staked += bet.units_placed
      @h3to7_pnl += bet.profit_or_loss
    end

    #Find total staked on odds over 7
    #Find PnL for odds over 7
    @ho7_total_staked = 0
    @ho7_pnl = 0
    for bet in @horse_over_7
      @ho7_total_staked += bet.units_placed
      @ho7_pnl += bet.profit_or_loss
    end

    #Separate the bets into place and win bets
    @horse_under_3_place = @bets.where("sport = ? AND odds < ? AND bet_placed like ?", 7, 3, "%to place%")
    @horse_under_3_win = @bets.where("sport = ? AND odds < ? AND bet_placed like ?", 7, 3, "%to win%")

    #Find total staked on place and win bets for under 3 odds
    @hu3win_total_staked = 0
    @hu3win_pnl = 0
    for bet in @horse_under_3_win
      @hu3win_total_staked += bet.units_placed
      @hu3win_pnl += bet.profit_or_loss
    end

    @hu3place_total_staked = 0
    @hu3place_pnl = 0
    for bet in @horse_under_3_place
      @hu3place_total_staked += bet.units_placed
      @hu3place_pnl += bet.profit_or_loss
    end

  end

end
