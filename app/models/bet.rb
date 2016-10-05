class Bet < ActiveRecord::Base

  default_value_for :date_of_bet, Date.today
  

end
