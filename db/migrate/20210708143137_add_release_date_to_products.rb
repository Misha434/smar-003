class AddReleaseDateToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :release_date, :datetime
  end
end
