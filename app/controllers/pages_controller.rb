class PagesController < ApplicationController
  def home
    @products_sorted_by_new_release = Product.with_attached_image.order('release_date DESC').limit(3)
    @products_sorted_by_antutu = Product.with_attached_image.order('soc_antutu_score DESC').limit(3)
    return unless user_signed_in?

    @products_sort_rate_average = Product.with_attached_image.order('rate_average DESC').limit(3)
    @products_sorted_by_battery = Product.with_attached_image.order('battery_capacity DESC').limit(3)
  end

  def terms; end
end
