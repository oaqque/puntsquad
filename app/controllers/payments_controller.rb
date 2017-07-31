require "uri"
require "net/http"
require 'multi_json'

class PaymentsController < ApplicationController
  def index
    if current_user.plan_id?
      flash[:success] = "You're already subscribed!"
      redirect_to root_url
    end
  end

  def checkout
    redirect_to paypal_url(params[:plan_id], payments_success_path)
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

  protect_from_forgery except: [:hook]

  def hook
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

    if params[:st] == "Completed"
      add_payment(@response["txn_id"], current_user.id)
      @plan_id = get_plan_id(@response["transaction_subject"])
      set_subscribed(current_user.id, @plan_id)
    else
      flash[:danger] = "Something went wrong! Please contact support for help if needed."
      redirect_to root_path
    end

  end

  def cancelled_payments
  end

  def add_payment(transaction_id, user_id)
    if Payment.exists?(transaction_id: transaction_id)
    else
      @payment = Payment.new(transaction_id: transaction_id, status: 'Completed', purchased_at: Time.now, user_id: user_id)
      @payment.save
    end
  end

  def get_plan_id(plan_name)
    if plan_name == 'SPORTS PACKAGE (1 Week)'
      @plan_id = 1
    elsif plan_name == 'SPORTS PACKAGE (1 Month)'
      @plan_id = 2
    elsif plan_name == 'SPORTS PACKAGE (1 Quarter)'
      @plan_id = 3
    elsif plan_name == 'SPORTS PACKAGE (1 Year)'
      @plan_id = 4
    end
    @plan_id
  end

  def set_subscribed(user_id, plan_id)
    if User.exists?(user_id)
      @user = User.find(user_id)
      @user.update_attributes plan_id: plan_id
      @user.save
    end
  end

end
