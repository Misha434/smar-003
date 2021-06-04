class PagesController < ApplicationController
  def home
    @user = current_user
    @products_sorted_by_battery = Product.with_attached_image.order('battery_capacity DESC').limit(3)
    @products_sorted_by_antutu = Product.with_attached_image.order('soc_antutu_score DESC').limit(3)
    @products_sorted_by_new_release = Product.with_attached_image.order('created_at DESC').limit(3) unless current_user.nil?
  end
  def terms
  end
end
