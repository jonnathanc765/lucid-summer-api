class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :payment_id
      t.integer :status, default: 0
      t.datetime :delivery_date

      t.timestamps
    end
  end
end
