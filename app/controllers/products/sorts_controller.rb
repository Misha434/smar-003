class Products::SortsController < ApplicationController
  before_action :authenticate_user!, only: :battery
  include Pagy::Backend

  def battery
    @pagy, @products = pagy(Product.with_attached_image.includes(:brand).all.order('battery_capacity DESC'))
  end
end