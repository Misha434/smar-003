module Products
  class SortsController < ApplicationController
    before_action :authenticate_user!, only: %i[antutu battery rate]
    include Pagy::Backend

    def antutu
      @pagy, @products = pagy(Product.with_attached_image.includes(:brand).all.order('soc_antutu_score DESC'))
    end

    def battery
      @pagy, @products = pagy(Product.with_attached_image.includes(:brand).all.order('battery_capacity DESC'))
    end

    def rate
      get_product_rate_average = Review.group('product_id').average(:rate).sort_by { |a| -a[1] }
      @products = []
      @average_rate = []
      unless get_product_rate_average.empty?
        product_amount = get_product_rate_average.size
        product_amount.times do |i|
          @products << Product.with_attached_image.find_by(id: get_product_rate_average[i][0])
          @average_rate << get_product_rate_average[i][1]
        end
      end
    end
  end
end
