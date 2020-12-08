class CreatePaymentMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_methods do |t|
      t.string :unique_id
      t.references :user, null: false, foreign_key: true
      t.string :hashed_card_number
      t.string :card_brand

      t.timestamps
    end
  end
end
