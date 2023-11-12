class ApplicationMailer < ActionMailer::Base
  default from: 'junhuangc@foxmail.com'

  def welcome_email
    @user = params[:user]
    @url = 'example.com'
    mail(to:@user.email, subject: 'Welcome to My Awesome Site')
  end
end
