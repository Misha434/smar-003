class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy new edit update]
  before_action :admin_user, only: %i[index]
  before_action :correct_user, only: %i[edit update destroy]
  include Pagy::Backend

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:notice] = "レビューを投稿しました"
      redirect_to @review.product
    else
      set_forms_brands_products
      flash.now[:denger] = "レビュー投稿が失敗しました"
      render '/reviews/new'
    end
  end

  def new
    set_forms_brands_products
    @review = Review.new
  end

  def index
    @pagy, @reviews = pagy(Review.includes(:user).with_attached_image.all)
  end

  def edit
    set_forms_brands_products
  end

  def update
    if @review.update(review_params)
      flash[:notice] = "レビューが更新されました"
      redirect_to current_user
    else
      set_forms_brands_products
      flash.now[:denger] = "更新失敗しました"
      render 'reviews/edit'
    end
  end

  def destroy
    if @review.destroy
      flash[:notice] = "レビューが消去されました"
      redirect_to @review.product || root_url
    else
      flash.now[:denger] = "レビュー消去が失敗しました"
      render 'reviews/edit'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :user_id, :product_id, :image, :rate)
  end

  def correct_user
    if current_user.admin?
      @review = Review.find_by(id: params[:id])
    else
      @review = current_user.reviews.find_by(id: params[:id])
      if @review.nil?
        flash[:denger] = "不正ユーザーのアクセスです"
        redirect_to root_url
      end
    end
  end
end
