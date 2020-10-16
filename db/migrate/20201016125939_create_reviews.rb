class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.references :reviewable, null: false, polymorphic: true
      t.string :title
      t.text :description
      t.integer :stars

      t.timestamps
    end
  end
end
