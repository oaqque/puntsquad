class MeetMailer < ActionMailer::Base
  default :from => "contact@puntsquad.com", :content_type => "multipart/mixed"

  def meet_email(name, user)
    @name = name
    @user = user
    mail(:to => user.email, :subject => "#{name} is ready")
  end
end
