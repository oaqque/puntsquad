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
        business: "merchant-success@puntsquad.com",
        no_shipping: 0,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        rm: 2,
        notify_url: "#{Rails.application.secrets.app_host}/hook",
        item_name: plan.name,
        currency_code: "AUD",
    }
    values = if plan.recurring
                values.merge(
                    cmd: "_xclick-subscriptions",
                    a3: plan.price,
                    p3: plan.duration,
                    t3: plan.period.first,
                    no_note: 1
                )
              end

    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end
end
