class ProductsController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create edit destroy search]
  before_action :admin_user, only: %i[new create edit update destroy]
  before_action :set_q, only: %i[index search]
  include Pagy::Backend

  def show
    if @product = Product.find(params[:id])
      @review = current_user.reviews.build if user_signed_in?
      @select_product_reviews = @product.reviews.includes(:user).with_attached_image
      @product_like_countup = Like.likes_count(params[:id])
      @products_for_compare = Compare.where('user_id=?', current_user.id).includes(product: [:brand, { image_attachment: :blob }]).all
    else
      flash[:danger] = '入力した製品は存在しません'
      redirect_to products_path
    end
  rescue ActiveRecord::RecordNotFound => e
    puts e
    @brands = Brand.all
    flash[:danger] = "入力した製品は存在しません"
    redirect_to request.referrer || root_path
  rescue StandardError => e
    puts e
  end

  def index
    @q = Product.with_attached_image.includes(:brand).ransack(params[:q])
    @pagy, @products = pagy(@q.result(distinct: true))
  end

  def edit
    @product = Product.find(params[:id])
    @brands = Brand.all
  rescue ActiveRecord::RecordNotFound => e
    puts e
    @brands = Brand.all
    flash[:danger] = "入力した製品は存在しません"
    redirect_to request.referrer || root_path
  rescue StandardError => e
    puts e
  end

  def new
    @product = Product.new
    @brands = Brand.all
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Add Product Successfully"
      redirect_to @product
    else
      @brands = Brand.all
      flash.now[:danger] = "Fail to Add Product"
      render 'new'
    end
  rescue ActiveRecord::RecordNotUnique => e
    puts e
    @brands = Brand.all
    flash.now[:danger] = "Cannot add a same product as same brand"
    render 'new'
  rescue StandardError => e
    puts e
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:success] = "Product updated"
      redirect_to @product
    else
      @brands = Brand.all
      render 'edit'
      flash.now[:success] = "Fail to update"
    end
  end

  def destroy
    Product.find(params[:id]).destroy
    redirect_to products_path
  end

  def search
    @pagy, @results = pagy(@q.result.with_attached_image.includes(:brand))
  end

  def import
    redirect_to products_path, notice: "Import is Succeeded" if Product.import(params[:file])
  end

  private

  def product_params
    params.require(:product).permit(:name, :brand_id, :soc_antutu_score, :battery_capacity, :image, :release_date)
  end

  def set_q
    @q = Product.ransack(params[:q])
  end
end
