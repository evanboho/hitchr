class NotifierMailer < ActionMailer::Base
  default :from 	=> "unnaive@gmail.com"
  
  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.firstname} <#{@user.email}>"
    @url = "http://example.com/login"
    mail(:to => email_with_name, :subject => "Welcome to hitchr!")
  end
end
