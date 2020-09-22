class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.string :color
      t.bigint :parent_id

      t.timestamps
    end
  end
end
