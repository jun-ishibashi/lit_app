class AddPriceIncludesToServices < ActiveRecord::Migration[7.2]
  def change
    add_column :services, :price_includes, :string
  end
end
