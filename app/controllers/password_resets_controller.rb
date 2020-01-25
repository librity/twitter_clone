# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    @user ? handle_password_reset_creation : handle_password_reset_failure
  end

  def edit; end

  def update
    handle_empty_params && return if params[:user][:password].empty?

    @user.update(user_params) ? handle_reset_success : handle_reset_failure
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_url
  end

  def handle_password_reset_creation
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = 'Email sent with password reset instructions.'
    redirect_to root_url
  end

  def handle_password_reset_failure
    flash.now[:danger] = 'Email address not found'
    render 'new'
  end

  def handle_empty_params
    @user.errors.add(:password, "can't be empty")
    render 'edit'
  end

  def handle_reset_success
    @user.clear_reset_digest
    log_in @user
    flash[:success] = 'Password has been reset.'
    redirect_to @user
  end

  def handle_reset_failure
    render('edit')
  end
end
