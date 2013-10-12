class ContactMailer < ActionMailer::Base
  default :from => 'seaneshbaugh@gmail.com'

  def contact_form_message(contact)
    @contact = contact

    mail :to => 'seaneshbaugh@gmail.com', :subject => "conneythecorgi.com Contact Form - #{@contact.subject}"
  end
end
