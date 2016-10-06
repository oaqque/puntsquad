class MeetsController < ApplicationController
  def new
    @meet = Meet.new
  end
  def create
    @meet = Meet.new(meet_params)
    @users = User.all
    if @meet.save
      name = params[:meet][:name]
      @users.each do |user|
        MeetMailer.meet_email(name, user).deliver_now
      end
      flash[:success] = 'Message sent.'
      redirect_to new_meet_path
    else
      flash[:danger] = 'Error occured, message has not been sent.'
      redirect_to new_meet_path
    end
  end

  private
    def meet_params
      params.require(:meet).permit(:name)
    end
end
