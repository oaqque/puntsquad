class HomeController < ApplicationController
  def index
    @weekly_plan = Plan.find(4)
    @monthly_plan = Plan.find(5)
    @yearly_plan = Plan.find(6)
  end
end
