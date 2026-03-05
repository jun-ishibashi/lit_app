class AddIncotermIdToQuoteRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :quote_requests, :incoterm_id, :integer
  end
end
