class AddExemptFieldToProduct < ActiveRecord::Migration[6.0]
  def change

    add_column :products, :exempt, :boolean, default: true
  end 
end
