class LikesController < ApplicationController
  before_action :review_params, only: %i[create destroy]

  def create
    @like = Like.new(user_id: current_user.id, review_id: params[:id])
    if @like.save
      flash[:notice] = "Like is success"
    else
      flash[:alert] = "Like is fail"
    end
    redirect_to request.referrer
  end

  def destroy
    Like.find_by(user_id: current_user.id, review_id: params[:id]).destroy
    redirect_to request.referrer
  end

  private

  def review_params
    @review = Review.find(params[:id])
  end
end
