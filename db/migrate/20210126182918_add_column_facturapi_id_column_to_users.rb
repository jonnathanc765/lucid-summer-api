class AddColumnFacturapiIdColumnToUsers < ActiveRecord::Migration[6.0]
  def change

    add_column :users, :facturapi_id, :string
    add_column :users, :rfc, :string
  end
end
