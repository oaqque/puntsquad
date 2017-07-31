require "uri"
require "net/http"
require 'multi_json'

class PaymentsController < ApplicationController
  protect_from_forgery except: [:hook]
  def index
    if current_user.plan_id?
      flash[:success] = "You're already subscribed!"
      redirect_to root_url
    end
  end

  def checkout
    @payment = Payment.new()
    if @payment.save
      redirect_to paypal_url(params[:plan_id], payments_success_path)
    else
      render new: true
    end
  end

  def paypal_url(plan_id, return_path)
    plan = Plan.find(plan_id)
    values = {
        business: "merchant-success@puntsquad.com", # Your PayPal ID
        no_shipping: 1,                             # Do not prompt for an address
        return: "#{Rails.application.secrets.app_host}#{return_path}",             # Return path after successful payment
        cancel_return: "#{Rails.application.secrets.app_host}#{payments_cancelled_payment_path}",
                                                    # Return path after cancelled payment
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

  def hook
    params.permit!
    status = params[:payment_status]
    if status == "Completed"
      @payment = Payments.find params[:invoice]
      @payment.update_attributes notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
    end
    render nothing: true
  end

  def success
    transaction_id = params[:tx]
    values = {
      cmd: "_notify-synch",
      tx: transaction_id,
      at: "UhmIx_syeiDHtUIWsHCcbCV3uNwwwmP539j3JxCkJ3JKbL9oFBLzyvXA1Oy"
    }

    response = Net::HTTP.post_form(URI.parse("#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?"), values).body

    response.tr!('+', ' ')
    response.gsub!('%28', '(')
    response.gsub!('%29', ')')
    response.gsub!('%40', '@')

    lines = response.lines

    for i in 0..24
      lines[i] = lines[i].chomp
    end

    responseHash = {}
    lines.each do |line|
      key, value = line.chomp.split("=")
      responseHash[key] = value
    end

    @response = responseHash

  end

  def cancelled_payments
  end
end
