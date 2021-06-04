class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :admin_user, only: :index
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @review = Review.new
    @reviews = @user.reviews
    @brands = Brand.all
    @products = Product.all
    # @user_received_like_countup = Like.joins(review: :user).where('users.id=?', params[:id]).count
  end
end
