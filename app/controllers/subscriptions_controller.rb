class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!, except: [:new]
  before_action :redirect_to_signup, only: [:new]

  def show
  end

  def new
    select_plan
    plan_id = params[:plan]
    @plan_id = params[:plan]
    if plan_id == '1040'
      @plan_description = "Weekly Subscription"
      @data_amount = "15.00"
    elsif plan_id == '1050'
      @plan_description = "Monthly Subscription"
      @data_amount = "49.00"
    elsif plan_id == '1060'
      @plan_description = "Yearly Subscription"
      @data_amount = "499.00"
    else
      flash[:notice] = "Error in Payment, please try again."
    end
  end

  def create
    # Get Plan ID and Stripe Token
    plan_id = params[:plan_id]
    token = params[:stripeToken]

    # Create a Stripe Customer

    customer = if current_user.stripeid?
      Stripe::Customer.retrieve(current_user.stripeid)
    else
      Stripe::Customer.create(email: current_user.email)
    end

    subscription = customer.subscriptions.create(
      source: params[:stripeToken],
      plan: plan_id
    )

    options = {
      stripeid: customer.id,
      stripe_subscription_id: subscription.id
    }

    options.merge!(
      card_last4: params[:card_last4],
      card_exp_month: params[:card_exp_month],
      card_exp_year: params[:card_exp_year],
      card_type: params[:card_brand]
    ) if params[:card_last4]

    current_user.update(options)

    redirect_to root_path
    flash[:success] = "Payment Succeeded."
  end

  def destroy
    customer = Stripe::Customer.retrieve(current_user.stripeid)
    subscription = customer.subscriptions.retrieve(current_user.stripe_subscription_id)
    subscription.delete

    current_user.update(stripe_subscription_id: nil)

    redirect_to root_path
    flash[:notice] = "Your subscription has been cancelled"
  end




  private
    def select_plan
      unless params[:plan] && (params[:plan] == '1040' || params[:plan] == '1050' || params[:plan] == '1060')
        flash[:notice] = "Please select the membership plan you wish to buy."
        redirect_to subscription_index_path
      end
    end

    def redirect_to_signup
      if !user_signed_in?
        session["user_return_to"] = subscription_path
        redirect_to new_user_registration_path
      end
    end


end
