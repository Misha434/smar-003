class Compare < ApplicationRecord
  COMPARE_PRODUCTS_MAX_VALUE = 2

  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true,
                      uniqueness: { scope: :product_id },
                      numericality: { only_integer: true,
                                      greater_than_or_equal_to: 1 }
  validates :product_id, presence: true,
                         numericality: { only_integer: true,
                                         greater_than_or_equal_to: 1 }

  validate :compares_count_must_be_within_limit

  private

  def compares_count_must_be_within_limit
    return unless !user.nil? && (user.compares.count >= COMPARE_PRODUCTS_MAX_VALUE)

    errors.add(:base, "#{COMPARE_PRODUCTS_MAX_VALUE}つ以上登録できません")
  end
end
