# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    user&.authenticate(params[:session][:password]) ?
    authenticate_user(user) :
    dont_authenticate_user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def authenticate_user(user)
    log_in(user)
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    redirect_to user
  end

  def dont_authenticate_user
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end
