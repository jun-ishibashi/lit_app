# frozen_string_literal: true

class CreateDeparturesAndDestinations < ActiveRecord::Migration[7.2]
  def up
    create_table :departures do |t|
      t.string :name, null: false
      t.integer :position, default: 0, null: false
    end
    create_table :destinations do |t|
      t.string :name, null: false
      t.integer :position, default: 0, null: false
    end

    # 既存の services.departure_id / destination_id と整合するため ID を指定して投入
    execute <<-SQL.squish
      INSERT INTO departures (id, name, position) VALUES
        (1, '--', 0), (2, '東京', 1), (3, '横浜', 2), (4, '名古屋', 3),
        (5, '大阪', 4), (6, '神戸', 5), (7, '博多', 6), (8, 'その他', 7);
    SQL
    execute <<-SQL.squish
      INSERT INTO destinations (id, name, position) VALUES
        (1, '--', 0), (2, 'Los Angeles', 1), (3, 'New York', 2), (4, 'London', 3),
        (5, 'Amsterdam', 4), (6, 'Barcelona', 5), (7, 'Hamburg', 6), (8, 'Shanghai', 7),
        (9, 'Hong Kong', 8), (10, 'Busan', 9), (11, 'Ho Chi Minh', 10), (12, 'Penang', 11),
        (13, 'Bangkok', 12), (14, 'Manila', 13), (15, 'Singapore', 14);
    SQL

    add_foreign_key :services, :departures
    add_foreign_key :services, :destinations

    return unless connection.adapter_name == "PostgreSQL"
    execute "SELECT setval(pg_get_serial_sequence('departures', 'id'), (SELECT COALESCE(MAX(id), 1) FROM departures));"
    execute "SELECT setval(pg_get_serial_sequence('destinations', 'id'), (SELECT COALESCE(MAX(id), 1) FROM destinations));"
  end

  def down
    remove_foreign_key :services, :departures
    remove_foreign_key :services, :destinations
    drop_table :destinations
    drop_table :departures
  end
end
