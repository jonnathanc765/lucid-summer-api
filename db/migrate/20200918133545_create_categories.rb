class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.string :color
      t.references :parent_category

      t.timestamps
    end
  end
end
