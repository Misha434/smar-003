class ComparesController < ApplicationController
  before_action :compare_params, only: %i[create destroy]
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @compare = current_user.compares.new(product_id: params[:id])
    if @compare.save(compare_params)
      flash[:notice] = "登録に成功しました"
    else
      @message = @compare.errors.full_messages.to_s.delete("^2つ以上登録できません")
      @message ||= "登録に失敗しました"
      flash[:danger] = @message
    end
    redirect_to product_path
  end

  def destroy
    @compare = current_user.compares.find_by(product_id: params[:id])
    if @compare.destroy
      flash[:notice] = "登録解除しました"
    else
      flash[:danger] = "登録解除に失敗しました"
    end
    redirect_to product_path
  end

  private

  def compare_params
    params.permit(:user_id, :product_id)
  end
end
