class ConfirmationsController < ApplicationController
  before_action :is_confirmed, only: [:questionary_get, :questionary_post]

  def questionary_get
  end

  def questionary_post
    old_user = User.find_by(email: user_params['email'])
    #tсли юзер с таким email есть
    if old_user
      user.authorizations.update_all(user_id: old_user.id)
      user.destroy
      old_user.update(is_confirmed: false, confirmation_token: user.confirmation_token)
      ConfirmationMailer.confirm_email(old_user).deliver_now
    else
      user.update(user_params)
      ConfirmationMailer.confirm_email(@user).deliver_now
      flash['succes'] = 'Follow the instructions in email'
      redirect_to '/'
    end
  end

  def confirm
    @user = User.find_by(confirmation_token: params[:token])
    if @user
      @user.update(is_confirmed: true)
      flash['success'] = 'Registration confirmed'
      sign_in_and_redirect @user, event: :authentication
    else
      flash['alert'] = 'Invalid token'
      redirect_to '/'
    end
  end

  private

  def is_confirmed
    if user.is_confirmed
      flash['alert'] = 'Already confirmed'
      redirect_to '/'
    end
  end

  def user
    @user ||= User.find(params[:user_id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
