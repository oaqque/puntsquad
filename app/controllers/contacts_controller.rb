class ContactsController < ApplicationController

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      ContactMailer.contact_email(name, email, body).deliver
      flash[:success] = 'Message sent.'
      redirect_to ""
    else
      flash[:success] = 'Error occured, message has not been sent.'
      redirect_to ""
    end
  end

  private
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end

end
