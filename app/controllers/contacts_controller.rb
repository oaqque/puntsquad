class ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)
    if @contact.save

      name = params[:contact][:name]
      email = params[:contact][:name]
      body = params[:contact][:comments]

      ContactMailer.contact_email(name, email, body).deliver

      flash[:success] = 'Message sent.'
      redirect_to :back
    else
      flash[:success] = 'Error occurred, message has not been sent.'
      redirect_to :back
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end
