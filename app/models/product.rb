class Product < ApplicationRecord
  belongs_to :brand
  has_many :reviews
  has_one_attached :image
  validates :brand_id, presence: true
  validates :name, presence: true, length: {in: 1..50}
  validates :soc_antutu_score, presence: true
  validates :battery_capacity, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
    message: "must be a valid image format" },
    size: { less_than: 5.megabytes,
    message: "should be less than 5MB" }
  
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
