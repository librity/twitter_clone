# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      handle_authentication_success
    else
      handle_authentication_failure
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def handle_authentication_success
    @user.activated? ? log_user_in : handle_activation_failure
  end

  def log_user_in
    log_in @user
    params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    redirect_back_to @user
  end

  def handle_activation_failure
    message = 'Account not activated.'
    message += 'Check your email for the activation link.'
    flash[:warning] = message
    redirect_to root_url
  end

  def handle_authentication_failure
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end
