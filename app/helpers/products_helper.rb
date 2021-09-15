module ProductsHelper
  def avarage_rate(product)
    Review.where('product_id=?', product.id).average(:rate).to_f
  end

  def ranking_title
    return if params[:q].nil?

    sort_by = {
      'release_date asc' => '新発売',
      'release_date desc' => '新発売',
      'battery_capacity asc' => 'バッテリー容量',
      'battery_capacity desc' => 'バッテリー容量',
      'soc_antutu_score asc' => 'Antutu',
      'soc_antutu_score desc' => 'Antutu',
      'rate_average asc' => 'レビュー平均',
      'rate_average desc' => 'レビュー平均'
    }
    sort_by[params[:q][:s]]
  end
end