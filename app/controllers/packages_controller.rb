class PackagesController < ApplicationController
  before_action :authenticate_user!

  def update
    # Grab Customer object from Stripe API
    customer = Stripe::Customer.retrieve(current_user.stripeid)
    # Grab the Subscription which the customer is currently subscribed to
    subscription = customer.subscriptions.retrieve(current_user.stripe_subscription_id)
    plan_id = params[:package]
    # Update the Subscription
    subscription.plan = plan_id
    subscription.save

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

    current_user.update(
      package: package,
      stripe_subscription_id: subscription.id
    )

    redirect_to edit_user_registration_path
    flash[:success] = "Success. You are now subscribed to a new plan."
  end
end
