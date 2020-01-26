# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    @micropost.save ? handle_save_success : handle_save_failure
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_back(fallback_location: root_url)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def handle_save_success
    flash[:success] = 'Micropost created!'
    redirect_to root_url
  end

  def handle_save_failure
    @feed_items = current_user.feed.paginate(page: params[:page])
    render 'static_pages/home'
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
