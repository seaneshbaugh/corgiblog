# frozen_string_literal: true

class ContactController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid?
      ContactJob.perform_later(@contact.to_json)

      render 'thanks'
    else
      render 'new'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number, :subject, :body)
  end
end
