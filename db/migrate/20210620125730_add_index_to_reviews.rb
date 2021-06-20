class AddIndexToReviews < ActiveRecord::Migration[6.0]
  def change
    add_index :reviews, [:product_id, :user_id], unique: true
  end
end
