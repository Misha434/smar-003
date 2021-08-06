class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy new edit update]
  before_action :correct_user, only: %i[destroy edit update]

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = "Review is created"
      redirect_to @review.product
    else
      set_forms_brands_products
      flash[:danger] = "Fail to create"
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
      flash[:success] = "Review is updated"
      redirect_to current_user
    else
      set_forms_brands_products
      flash[:danger] = "Updated is failed"
      render 'reviews/edit'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :user_id, :product_id, :image, :rate)
  end

  def correct_user
    @review = current_user.reviews.find_by(id: params[:id])
    redirect_to root_url if @review.nil?
  end
end
