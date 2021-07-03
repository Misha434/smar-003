class User < ApplicationRecord
  before_save { email.downcase! }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  has_many :reviews, dependent: :destroy
  has_many :products
  has_many :likes
  validates :name, presence: true, length: { in: 1..140 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
  length: { in: 3..254 }
  VALID_PASSWORD_REGEX = /\A[\w!@#%^&*]{8,}\z/
  validates :password, presence: true, allow_nil: true, format: { with: VALID_PASSWORD_REGEX }
  validates :password_confirmation, presence: true, allow_nil: true, format: { with: VALID_PASSWORD_REGEX }

  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                                     message: "must be a valid image format" },
                     size: { less_than: 5.megabytes, message: "should be less than 5MB" }

  def display_image
    image.variant(resize_to_limit[44, 44])
  end

  def liked_by?(review_id)
    likes.where(review_id: review_id).exists?
  end
end
