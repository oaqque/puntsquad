class Users::RegistrationsController < Devise::RegistrationsController

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path
      flash[:success] = "You've successfully signed up. Check your email to authenticate your email"
    else
      render 'new'
      flash[:danger] = 'Something went wrong. Please try again.'

    end
  end

  def edit
    @invoices = Payment.where(user_id: current_user.id)
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
