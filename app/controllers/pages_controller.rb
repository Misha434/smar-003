class PagesController < ApplicationController
  def home
    @products_sorted_by_battery = Product.with_attached_image.order('battery_capacity DESC').limit(3)
    @products_sorted_by_antutu = Product.with_attached_image.order('soc_antutu_score DESC').limit(3)
    @each_product_rate_average = Review.group('product_id').average(:rate).sort_by { |a| -a[1] } [0..2]
    @products_sort_rate_average = []
    @average_rate = []
    unless @each_product_rate_average.empty?
      product_amount = @each_product_rate_average.size
      product_amount.times do |i|
        @products_sort_rate_average << Product.with_attached_image.find_by(id: @each_product_rate_average[i][0])
        @average_rate << @each_product_rate_average[i][1]
      end
    end
    @products_sorted_by_new_release = Product.with_attached_image.order('release_date DESC').limit(3)
  end

  def terms; end
end
