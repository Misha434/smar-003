class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :soc_antutu_score
      t.integer :battery_capacity
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
