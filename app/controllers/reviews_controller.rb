class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy new edit update]
  before_action :correct_user, only: %i[destroy edit update]

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_to current_user
    else
      @brands = Brand.all
      @products = Product.all
      render '/reviews/new'
    end
  end

  def new
    @brands = Brand.all
    @products = Product.all
    @review = Review.new
  end

  def destroy
    @review = Review.find_by(params[:id])
    if @review.destroy
      flash[:success] = "Review is deleted"
      redirect_to @review.product || root_url
    end
  end

  def edit
    @review = Review.find(params[:id])
    @brands = Brand.all
    @products = Product.all
  end

  def update
    # @review.image.purge if @review.image.attached?
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to current_user
    else
      @brands = Brand.all
      @products = Product.all
      render 'edit'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :user_id, :product_id, :image)
  end

  def correct_user
    @review = Review.find(params[:id])
    redirect_to root_url if @review.nil?
    redirect_to current_user || root_url unless current_user.id == @review.user_id
  end
end
