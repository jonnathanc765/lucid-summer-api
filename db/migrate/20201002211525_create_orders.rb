class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.integer :status

      t.timestamps
    end
  end
end
