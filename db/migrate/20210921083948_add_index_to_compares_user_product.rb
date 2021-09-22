class AddIndexToComparesUserProduct < ActiveRecord::Migration[6.0]
  def change
    add_index :compares, [:product_id, :user_id], unique: true
  end
end
