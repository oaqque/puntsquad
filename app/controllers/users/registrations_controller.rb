class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if params[:plan]
        resource.plan_id = params[:plan]
        if resource.plan_id == 4 || resource.plan_id == 5 || resource.plan_id == 6
          resource.save_with_payment
        else
        end
      end
    end
  end
end
