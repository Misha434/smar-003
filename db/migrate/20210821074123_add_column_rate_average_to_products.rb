class AddColumnRateAverageToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :rate_average, :float, default: 0.0
  end
end
