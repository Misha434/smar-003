class ProductsController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create edit destroy]
  before_action :admin_user, only: %i[new create edit update destroy]
  include Pagy::Backend
  def show
    begin
      @product = Product.find(params[:id])
      if @product
        @select_product_reviews = @product.reviews.all
        @product_like_countup = Like.all.joins(review: :product).where('product_id=?', params[:id]).count
        @review_rate_average = Review.where('product_id=?', params[:id]).average(:rate)
        unless @review_rate_average == nil
          @review_rate_average = @review_rate_average.floor(1)
        end
        @review_rate_average ||= '-'
      else
        redirect_to products_path
        flash[:danger] = 'Product does not exist'
      end
    rescue ActiveRecord::RecordNotFound => e
      @brands = Brand.all
      flash[:danger] = "Product does not exist"
      redirect_to request.referrer || root_path
    rescue StandardError => e
      puts e
    end
  end
  
  def edit
    begin
      @product = Product.find(params[:id])
      @brands = Brand.all
    rescue ActiveRecord::RecordNotFound => e
      @brands = Brand.all
      flash[:danger] = "Product does not exist"
      redirect_to request.referrer || root_path
    rescue StandardError => e
      puts e
    end
  end

  def new
    @product = Product.new
    @brands = Brand.all
  end

  def create
    begin
    @product = Product.new(product_params)
      if @product.save
        flash[:success] = "Add Product Successfully"
        redirect_to @product
      else
        @brands = Brand.all
        render 'new'
      end
    rescue ActiveRecord::RecordNotUnique => e
      @brands = Brand.all
      flash[:danger] = "Cannot add a same product as same brand"
      render 'new'
    rescue StandardError => e
      puts e
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:success] = "Product updated"
      redirect_to @product
    else
      @brands = Brand.all
      render 'edit'
    end
  end

  def index
    @pagy, @products = pagy(Product.all)
  end

  def destroy
    Product.find(params[:id]).destroy
    redirect_to products_path
  end

  # Add import method in Brand controller
  # def import
  #   if Brand.import(params[:file])
  #     redirect_to products_path, notice: "Import is Succeeded"
  #   end
  # end

  private

  def product_params
    params.require(:product).permit(:name, :brand_id, :soc_antutu_score, :battery_capacity, :image)
  end
end
