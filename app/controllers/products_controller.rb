class ProductsController < ApplicationController
	before_action :authenticate_user!, only: [:index, :new, :create, :edit, :destroy]
	before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
	
  def show
    @product = Product.find(params[:id])
    @select_product_reviews = @product.reviews.all
    @product_like_countup = Like.all.joins(review: :product).where('product_id=?', params[:id]).count
  end

  def edit
    @product = Product.find(params[:id])
    @brands = Brand.all
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
      render 'new'
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
    @products = Product.all
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