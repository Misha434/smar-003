module ProductsHelper
  def avarage_rate(product)
    product.rate_average.zero? ? "-" : product.rate_average
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

  def star_indicator(product)
    if product.rate_average.zero?
      content_tag(:i, class: "fas fa-star mt-1")
    else
      product.rate_average.floor.times do
        content_tag(:i, class: "fas fa-star active_star mt-1")
      end
      # 0.5 means base value for half-star should be indicated
      if product.rate_average % 1 >= 0.5
        content_tag(:i, class: "fas fa-star-half-alt active_star mt-1")
      end
      # 5 means max value of rating
      (5 - product.rate_average.round).times do
        content_tag(:i, class: "far fa-star no_active_star mt-1")
      end
    end
  end
end
