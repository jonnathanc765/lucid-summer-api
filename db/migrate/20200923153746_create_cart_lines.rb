class CreateCartLines < ActiveRecord::Migration[6.0]
  def change
    create_table :cart_lines do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.string :unit_type

      t.timestamps
    end
  end
end
