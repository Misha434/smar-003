class ComparesController < ApplicationController
  # before_action :compare_params, only: %i[destroy]
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    Compare.create(user_id: current_user.id, product_id: params[:id])
    flash[:notice] = "Add Bookmark Successfully"
    redirect_to product_path
  end
  
  def destroy
    Compare.find_by(user_id: current_user.id, product_id: params[:id]).destroy
    flash[:notice] = "Remove Bookmark Successfully"
    redirect_to product_path
  end

  private

  def compare_params
    @compare = Compare.find(params[:id])
  end
end