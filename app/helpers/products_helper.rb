module ProductsHelper
  def avarage_rate(product)
    Review.where('product_id=?', product.id).average(:rate).to_f
  end

  def ranking_title
    return if params[:q].nil?

    sort_by = {
      'release_date asc' => 'New Release',
      'release_date desc' => 'New Release',
      'battery_capacity asc' => 'Battery ranking',
      'battery_capacity desc' => 'Battery ranking',
      'soc_antutu_score asc' => 'Antutu ranking',
      'soc_antutu_score desc' => 'Antutu ranking',
      'rate_average asc' => 'Review Rate ranking',
      'rate_average desc' => 'Review Rate ranking'
    }
    sort_by[params[:q][:s]]
  end
end
