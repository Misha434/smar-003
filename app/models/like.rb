class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review

  def self.likes_count(product_id)
    Like.joins(review: :product).includes(%i[review product]).where('product_id=?', product_id).count
  end
end
