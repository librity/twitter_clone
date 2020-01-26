# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.save ? handle_save_success : handle_save_failure
  end

  def destroy; end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def handle_save_success
    flash[:success] = 'Micropost created!'
    redirect_to root_url
  end

  def handle_save_failure
    render 'static_pages/home'
  end
end
