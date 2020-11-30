class AddColumnDateOfDeliveryToColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :delivery_date, :datetime
  end
end
