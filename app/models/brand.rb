class Brand < ApplicationRecord
  has_many :products, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  validates :name, presence: true, uniqueness: { case_sensitive: false },
                   length: { maximum: 50 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }

  def self.csv_attributes
    ["name"]
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      brand = new
      brand.attributes = row.to_hash.slice(*csv_attributes)
      begin
        brand.save!
      rescue StandardError => e
        puts e.class
      end
    end
  end
end
