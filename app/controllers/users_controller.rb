class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index show]
  before_action :admin_user, only: :index
  include Pagy::Backend
  def index
    @pagy, @users = pagy(User.all)
  end

  def show
    begin
      @user = User.find(params[:id])
      @reviews = @user.reviews
    rescue ActiveRecord::RecordNotFound => e
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
