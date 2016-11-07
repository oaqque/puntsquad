class MeetMailer < ActionMailer::Base
  default :from => "contact@puntsquad.com", :content_type => "multipart/mixed"

  def meet_email(name, user)
    @name = name
    @user = user
    mail(:to => user.email, :subject => "Your bets from #{name} are now ready")
    headers['X-SMTPAPI'] = '{"asm_group_id": 1503, "asm_groups_to_display": [1503, 1507]}'
  end

end
