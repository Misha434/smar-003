class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user_id, presence: true,
                      uniqueness: { scope: :review_id },
                      numericality: { only_integer: true,
                                      greater_than_or_equal_to: 1 }
  validates :review_id, presence: true,
                        numericality: { only_integer: true,
                                         greater_than_or_equal_to: 1 }

  def self.likes_count(product_id)
    Like.joins(review: :product).includes(%i[review product]).where('product_id=?', product_id).count
  end
end
