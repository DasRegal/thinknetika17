class ConfirmationsController < ApplicationController
  def questionary_get
    @user = User.find(params[:user_id])
  end

  def questionary_post
    #если впервые юзер заходит
    @user = User.find(params[:user_id])
    @user.update(user_params)
    ConfirmationMailer.confirm_email(@user).deliver_now
    redirect_to '/'
  end

  def confirm
    @user = User.find_by(confirmation_token: params[:token])
    @user.update(confirmed_at: Time.now)
    flash['success'] = 'Registration confirmed'
    redirect_to '/'
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
