class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.integer :departure_id,             null: false
      t.integer :destination_id,           null: false
      t.integer :service_type_id,          null: false
      t.integer :price,                    null:false
      t.integer :lead_time,                null: false
      t.integer :option_id,                null: false
      t.text :description
      t.references :provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
