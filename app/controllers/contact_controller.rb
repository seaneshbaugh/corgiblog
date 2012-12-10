class ContactController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])

    if @contact.valid?
      ContactMailer.contact_form_message(@contact).deliver

      flash[:success] = 'Thank you for your message! Conney will get back to you soon.'

      redirect_to root_url
    else
      render 'new'
    end
  end
end
