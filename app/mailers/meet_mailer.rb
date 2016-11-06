class MeetMailer < ActionMailer::Base
  default :from => "contact@puntsquad.com", :content_type => "multipart/mixed"

  def meet_email(name, user)
    @name = name
    @user = user
    mail(:to => user.email, :subject => "Your bets from #{name} are now ready")
  end

end
