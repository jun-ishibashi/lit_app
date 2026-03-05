class AddCargoFieldsToQuoteRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :quote_requests, :weight_kg, :decimal, precision: 12, scale: 3
    add_column :quote_requests, :volume_cbm, :decimal, precision: 12, scale: 4
    add_column :quote_requests, :quantity, :integer
  end
end
