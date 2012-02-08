class UserMailer < ActionMailer::Base
  default :from => "admin@conneythecorgi.com"

  def welcome(user)
    @user = user

    mail :to => user.email_address, :subject => "Welcome to conneythecorgi.com!"
  end

  def password_reset(user)
    @user = user

    mail :to => user.email_address, :subject => "conneythecorgi.com - Password Reset"
  end
end
