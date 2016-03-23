class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!

  def show
  end

  def new
    select_plan
    plan_id = params[:plan]
    if plan_id == '1040'
      @plan_description = "Weekly Subscription"
      @data_amount = "1500"
    elsif plan_id == '1050'
      @plan_description = "Monthly Subscription"
      @data_amount = "4900"
    elsif plan_id == '1060'
      @plan_description = "Yearly Subscription"
      @data_amount = "49900"
    else
      flash[:notice] = "Error in Payment, please try again."
    end
  end

  def create

    # Get Plan ID and Stripe Token
    plan_id = params[:plan]
    token = params[:stripeToken]

    # Create a Stripe Customer

    customer = Stripe::Customer.create(
      :source => token,
      :plan => plan_id,
      :email => current_user.email
    )

    current_user.subscribed = true
    current_user.stripeid = customer.id
    current_user.save

    redirect_to root_path

  end




  private
    def select_plan
      unless params[:plan] && (params[:plan] == '1040' || params[:plan] == '1050' || params[:plan] == '1060')
        flash[:notice] = "Please select the membership plan you wish to buy."
        redirect_to subscription_index_path
      end
    end


end
