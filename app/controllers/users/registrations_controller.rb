class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :select_plan, only: [:new, :create]

  def create
    super do |resource|
      if params[:plan]
        resource.plan_id = params[:plan]
        if resource.plan_id == 4 || resource.plan_id == 5 || resource.plan_id == 6
          resource.save_with_payment
        else
          redirect_to root_url
          flash[:Danger] = "There was an error with processing your payment. Please try again."
        end
      end
    end
  end

  private

    def select_plan
      unless params[:plan] && (params[:plan] == '4' || params[:plan] == '5' || params[:plan] == '6')
      flash[:notice] = "Please select a membership plan to sign up."
      redirect_to root_url
    end
    end
end
