class BetsController < ApplicationController
  def new
    @bet = Bet.new
  end

  def create
    @bets = Bet.new(bet_params)

    if @bets.save
        flash[:success] = 'Bet Successfull Logged.'
        redirect_to new_bet_path
      else
        flash[:danger] = 'Error, Bet has not been logged. Try again mate.'
        redirect_to new_bet_path
      end
  end

  private

    def bet_params
      params.require(:bet).permit(:bet_placed, :game, :units_placed, :odds, :profit_or_loss)
    end

end
