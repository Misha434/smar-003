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
  has_many :compares
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    length: { maximum: 254 }
  VALID_PASSWORD_REGEX = /\A[\w!@#%^&*]{8,}\z/.freeze
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

  def marked_by?(product_id)
    compares.where('product_id=?', product_id).exists?
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = "Guest"
      user.password = SecureRandom.hex(13)
    end
  end
end
