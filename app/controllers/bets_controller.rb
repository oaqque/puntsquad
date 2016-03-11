class BetsController < ApplicationController

  before_action :authenticate_user!

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

  def show
    @bet = Bet.find(params[:id])
  end

  def edit
    @bet = Bet.find(params[:id])
  end

  def update
    @bet = Bet.find(params[:id])

        if @bet.update_attributes(bet_params)
            flash[:success] = "Bet Updated!"
            redirect_to bet_path(params[:id])
        else
            render action: :edit
        end
  end

  private

    def bet_params
      params.require(:bet).permit(:bet_placed, :game, :units_placed, :odds, :profit_or_loss, :date_of_bet, :resolved, :push)
    end

end
