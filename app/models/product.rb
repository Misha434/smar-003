class Product < ApplicationRecord
  belongs_to :brand
  has_many :reviews, dependent: :destroy
  has_many :compares
  has_one_attached :image
  validates :brand_id, presence: true
  validates :name, presence: true, length: { in: 1..50 }
  validates :soc_antutu_score, presence: true,
                               numericality: { only_integer: true,
                                               greater_than_or_equal_to: 1 }
  validates :battery_capacity, presence: true,
                               numericality: { only_integer: true,
                                               greater_than_or_equal_to: 1 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }
  validates :release_date, presence: true

  def update_rate_average
    reviews_rate = reviews.average(:rate)
    reviews_rate ||= 0
    update!(rate_average: reviews_rate)
  end

  # def self.csv_attributes
  # 	["name", "brand_id", "soc_antutu_score", "battery_capacity"]
  # end

  # def self.import(file)
  # 	CSV.foreach(file.path, headers: true) do |row|
  # 		product = new
  # 		product.attributes = row.to_hash.slice(*csv_attributes)
  # 		begin
  # 			product.save!
  # 		rescue => e
  # 			puts e.class
  # 		end
  # 	end
  # end
end
