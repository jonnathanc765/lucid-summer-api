class CreateOrderLines < ActiveRecord::Migration[6.0]
  def change
    create_table :order_lines do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.string :unit_type
      t.float :price
      t.boolean :check

      t.timestamps
    end
  end
end
