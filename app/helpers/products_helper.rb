module ProductsHelper
  def avarage_rate(product)
    Review.where('product_id=?', product.id).average(:rate).to_f
  end
end
