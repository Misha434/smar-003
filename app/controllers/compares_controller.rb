class ComparesController < ApplicationController
  before_action :compare_params, only: %i[create destroy]
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @compare = Compare.new(user_id: current_user.id, product_id: params[:id])
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
    @compare = Compare.find_by(user_id: current_user.id, product_id: params[:id])
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
