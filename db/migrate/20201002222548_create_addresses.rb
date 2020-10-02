class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
