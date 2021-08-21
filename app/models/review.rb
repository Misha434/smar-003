class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_one_attached :image
  # default_scope -> { order(created_at: :desc)}
  has_many :likes, dependent: :destroy

  validates :user_id, presence: true,
                      numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :product_id, presence: true,
                         numericality: { only_integer: true,
                                         greater_than_or_equal_to: 1 }
  validates :rate, presence: true,
                   numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1,
                                   less_than_or_equal_to: 5 }
  validates :content, presence: true, length: { in: 1..140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }
  after_save :update_rate_average
  after_destroy :update_rate_average

  def update_rate_average
    product.update_rate_average
  end
end
