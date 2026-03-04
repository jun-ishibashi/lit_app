class CreateQuoteRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :quote_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.text :message
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
