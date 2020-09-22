class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.belongs_to :category, foreign_key: "category_id"
      t.string :name
      t.float :retail_price
      t.float :wholesale_price
      t.float :promotion_price
      t.float :approximate_weight_per_piece

      t.timestamps
    end
  end
end
