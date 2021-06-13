class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index show]
  before_action :admin_user, only: :index
  include Pagy::Backend
  def index
    @pagy, @users = pagy(User.all)
  end

  def show
    @user = User.find(params[:id])
    @review = Review.new
    @reviews = @user.reviews
    @brands = Brand.all
    @products = Product.all
    @user_received_like_countup = Like.joins(review: :user).where('users.id=?', params[:id]).count
  end
end
