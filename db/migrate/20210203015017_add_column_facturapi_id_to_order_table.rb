class AddColumnFacturapiIdToOrderTable < ActiveRecord::Migration[6.0]
  def change

    add_column :orders, :facturapi_id, :string

  end
end
