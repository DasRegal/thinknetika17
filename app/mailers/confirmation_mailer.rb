class ConfirmationMailer < ApplicationMailer
  def confirm_email(user)
    @user = user
    @confirmation_token= @user.confirmation_token
    mail(to: @user.email, subject: 'Confirm your registration')
  end
end
