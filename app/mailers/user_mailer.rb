class UserMailer <  ActionMailer::Base
  default from: "reg@linuxpath.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome!")
  end

  def password_reset(user)
    @user = user
    mail(to: @user.email, subject: "Password reset")
  end
end
