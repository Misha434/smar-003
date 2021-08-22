class UsersController < ApplicationController
  before_action :authenticate_user!, only: :index
  before_action :admin_user, only: :index
  include Pagy::Backend

  def index
    @pagy, @users = pagy(User.with_attached_avatar.all)
  end

  def show
    begin
      @user = User.find(params[:id])
      @reviews = @user.reviews.includes(product: [image_attachment: :blob]).with_attached_image
    rescue ActiveRecord::RecordNotFound => e
      puts e
      @brands = Brand.all
      flash[:danger] = "User does not exist"
      redirect_to request.referrer || root_path
    rescue StandardError => e
      puts e
    end
    @review = Review.new
    @brands = Brand.all
    @products = Product.all
    @user_received_like_countup = Like.joins(review: :user).where('users.id=?', params[:id]).count
  end
end
