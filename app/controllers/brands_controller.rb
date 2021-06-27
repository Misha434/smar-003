class BrandsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit destroy]
  before_action :admin_user, only: %i[new create edit update destroy]
  include Pagy::Backend
  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      flash[:success] = "Add Brand Successfully"
      redirect_to @brand
    else
      render 'new'
    end
  end

  def index
    @pagy, @brands = pagy(Brand.all)
  end

  def show
    @brand = Brand.find(params[:id])
    if @brand.nil?
      flash[:denger] = "Brand is not exist"
      redirect_to brands_path
    else
      @brand
    end
  end

  def destroy
    @brand = Brand.find(params[:id])
    if @brand.destroy
      # @brand.image.purge if @brand.image.attched?
      flash[:success] = "Brand is deleted"
      redirect_to brands_path
    elsif current_user.admin == true
      flash[:denger] = "Fail to delete Brand"
      render 'edit'
    else
      flash[:denger] = "Prohibit to Access This Page"
      redirect_to request.referrer || root_url
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update(brand_params)
      flash[:success] = "Brand is updated"
      redirect_to @brand
    else
      render 'edit'
    end
  end

  def import
    redirect_to brands_path, notice: "Import is Succeeded" if Brand.import(params[:file])
  end

  private

  def brand_params
    params.require(:brand).permit(:name, :image)
  end
end
