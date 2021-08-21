module ProductsHelper
  def avarage_rate(product)
    Review.where('product_id=?', product.id).average(:rate).to_f
  end
  def ranking_title
    unless params[:q].nil?
      case params[:q][:s]
        when "release_date asc"
          "New Release"
        when "release_date desc"
          "New Release"
        when "battery_capacity asc"
          "Battery ranking"
        when "battery_capacity desc"
          "Battery ranking"
        when "soc_antutu_score asc"
          "Antutu ranking"
        when "soc_antutu_score desc" 
          "Antutu ranking"
        when "rate_average desc"
        when "rate_average asc"
      end
    end
  end
end
