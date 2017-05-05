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
        business: "billing@puntsquad.com",
        no_shipping: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        notify_url: "#{Rails.application.secrets.app_host}/hook",
        item_name: plan.name
    }
    values = if plan.recurring
                values.merge(
                    cmd: "_xclick-subscriptions",
                    a3: plan.price,
                    p3: plan.duration,
                    t3: plan.period.first,
                    srt: plan.cycles,
                )
              else
                values.merge(
                    cmd: "_xclick",
                    amount: plan.price,
                    item_number: plan.id,
                    quantity: '1'
                )
              end

    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end
end
