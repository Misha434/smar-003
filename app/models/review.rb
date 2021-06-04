class Review < ApplicationRecord
  belongs_to :user
  # belongs_to :product
  has_one_attached :image
  # default_scope -> { order(created_at: :desc)}
  # has_many :likes, dependent: :destroy
  
  validates :user_id, presence: true
  # validates :product_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], \
    message: "must be a valid image format" }, \
    size: { less_than: 5.megabytes, \
    message: "should be less than 5MB" }
end
