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
      @plan_description = "Basic Weekly Plan"
      @data_amount = "50.00"
    elsif plan_id == '1050'
      @plan_description = "Basic Monthly Plan"
      @data_amount = "150.00"
    elsif plan_id == '1060'
      @plan_description = "Basic Quarterly Plan"
      @data_amount = "400.00"
    elsif plan_id == '1070'
      @plan_description = "Basic Yearly Plan"
      @data_amount = "1300"
    elsif plan_id == '2040'
      @plan_description = "Premium Weekly Plan"
      @data_amount = "150.00"
    elsif plan_id == '2050'
      @plan_description = "Premium Monthly Plan"
      @data_amount = "500.00"
    elsif plan_id == '2060'
      @plan_description = "Premium Quarterly Plan"
      @data_amount = "1500"
    elsif plan_id == '2070'
      @plan_description = "Premium Yearly Plan"
      @data_amount = "5000"
    else
      flash[:notice] = "Please Select a Plan First."
    end
  end

  def create
    # Get Plan ID and Stripe Token
    plan_id = params[:plan_id]
    token = params[:stripeToken]

    # For updating the current_user Package
    if plan_id == '1040'
      package = 'Basic Weekly'
    elsif plan_id == '1050'
      package = 'Basic Monthly'
    elsif plan_id == '1060'
      package = 'Basic Quarterly'
    elsif plan_id == '1070'
      package = 'Basic Yearly'
    elsif plan_id == '2040'
      package = 'Premium Weekly'
    elsif plan_id == '2050'
      package = 'Premium Monthly'
    elsif plan_id == '2060'
      package = 'Premium Quarterly'
    elsif plan_id == '2070'
      package = 'Premium Yearly'
    end

    # Create a Stripe Customer
    begin
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
        stripe_subscription_id: subscription.id,
        package: package
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
    rescue Stripe::CardError => e
      redirect_to new_subscription_path(:plan => plan_id)
      flash[:danger] = 'Card Declined. You have not been charged. Please try again or contact support.'
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
      redirect_to new_subscription_path(:plan => plan_id)
      flash[:danger] = 'Rate Limit Error. You have not been charged. Please wait and try again later.'
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      redirect_to new_subscription_path(:plan => plan_id)
      flash[:danger] = 'Invalid Request Error. You have not been charged. Please try again or contact support.'
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      redirect_to new_subscription_path(:plan => plan_id)
      flash[:danger] = 'Stripe API Declined. Please contact support.'
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      redirect_to new_subscription_path(:plan => plan_id)
      flash[:danger] = 'Network Connection Error. Please contact support.'
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      redirect_to new_subscription_path(:plan => plan_id)
      flash[:danger] = 'Stripe Error. Please contact support.'
    rescue => e
      # Something else happened, completely unrelated to Stripe
      redirect_to new_subscription_path(:plan => plan_id)
      flash[:danger] = 'Unknown Error.'
    end
  end

  def destroy
    customer = Stripe::Customer.retrieve(current_user.stripeid)
    subscription = customer.subscriptions.retrieve(current_user.stripe_subscription_id)
    subscription.delete

    current_user.update(stripe_subscription_id: nil, package: nil)

    redirect_to root_path
    flash[:notice] = "Your subscription has been cancelled"
  end




  private
    def select_plan
      unless params[:plan] && (params[:plan] == '1040' || params[:plan] == '1050' || params[:plan] == '1060' || params[:plan] == '1070' || params[:plan] == '2040' || params[:plan] == '2050' || params[:plan] == '2060' || params[:plan] == '2070')
        redirect_to subscription_path
        flash[:notice] = "Please select the membership plan you wish to buy."
      end
    end

    def redirect_to_signup
      if !user_signed_in?
        session["user_return_to"] = subscription_path
        redirect_to new_user_registration_path
      end
    end


end
