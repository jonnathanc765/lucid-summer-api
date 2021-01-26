class CreateCoordinates < ActiveRecord::Migration[6.0]
  def change
    create_table :coordinates do |t|
      t.string :zip_code

      t.timestamps
    end
  end
end
