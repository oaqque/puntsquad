class PaymentsController < ApplicationController
  def index
  end

  def confirmation
    @plan_id = params[:plan_id]
  end

  def checkout
    plan_id = params[:plan_id]
    redirect_to paypal_url(root_url, plan_id)
  end

  def paypal_url(return_path, plan_id)
    plan = Plan.find(plan_id)
    values = {
        business: "merchant-success@puntsquad.com", # Your PayPal ID
        no_shipping: 1,                             # Do not prompt for an address
        return: "http://puntsquad.com",             # Return path after successful payment
        cancel_return: "http://puntsquad.com",                          # Return path after cancelled payment
        rm: 2,                                      # Post Method and all payment variables included
        notify_url: "#{Rails.application.secrets.app_host}/hook", #
        item_name: plan.name,                       # Description of item_name
        currency_code: "AUD",                       # Currency Code
    }
    values = if plan.recurring
                values.merge(
                    cmd: "_xclick-subscriptions",   # The button that the person clicked was a Subscribe button
                    a3: plan.price,                 # Price of the Plan per instalment
                    p3: plan.duration,              # Duration of subscription specified in T3
                    t3: plan.period.first,          # Week/Month/Year
                    src: 1,                         # Subscriptions payment recur 1.
                    no_note: 1                      # Required, always set to 1 for subscribe button
                )
              end

    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end

  def success
  end

  def cancelled_payment
  end
  
end
