# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    @user = User.find_by(email: params[:email])
    if @user&.authenticated?(:activation, params[:id]) && !@user.activated?
      handle_activation
    else
      handle_failure
    end
  end

  private

  def handle_activation
    @user.activate
    log_user_in
  end

  def log_user_in
    log_in @user
    flash[:success] = 'Account activated!'
    redirect_to @user
  end

  def handle_failure
    flash[:danger] = 'Invalid activation link'
    redirect_to root_url
  end
end
