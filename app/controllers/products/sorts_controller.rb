class Products::SortsController < ApplicationController
  before_action :authenticate_user!, only: :battery
  include Pagy::Backend

  def antutu
    @pagy, @products = pagy(Product.with_attached_image.includes(:brand).all.order('soc_antutu_score DESC'))
  end

  def battery
    @pagy, @products = pagy(Product.with_attached_image.includes(:brand).all.order('battery_capacity DESC'))
  end
end