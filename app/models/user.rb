class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  has_one_attached :avatar
  # has_many :reviews, dependent: :destroy
  # has_many :products
  # has_many :likes
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, length: {in: 3..254}
  validates :password, presence: true, allow_nil: true
  validates :password_confirmation, presence: true, allow_nil: true
  
  validates :avatar, content_type: {in: %w[image/jpeg image/gif image/png], \
    message: "must be a valid image format" }, \
    size: {less_than: 5.megabytes, message: "should be less than 5MB"}
  
  def display_image
    image.variant(resize_to_limit[44,44])
  end
  
  # def liked_by?(review_id)
  #   likes.where(review_id: review_id).exists?
  # end
end
