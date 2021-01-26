class AddColumnSatToProductsTable < ActiveRecord::Migration[6.0]
  def change

    add_column :products, :sat, :string
  end
end
