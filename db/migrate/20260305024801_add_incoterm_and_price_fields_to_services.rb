class AddIncotermAndPriceFieldsToServices < ActiveRecord::Migration[7.2]
  def change
    add_column :services, :incoterm_id, :integer
    add_column :services, :price_type, :string, default: "total", null: false
    add_column :services, :price_unit, :string
    add_column :services, :container_size_id, :integer
  end
end
