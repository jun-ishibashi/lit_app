class AddServiceScopeIdToServices < ActiveRecord::Migration[7.2]
  def change
    add_column :services, :service_scope_id, :integer, default: 1
  end
end
