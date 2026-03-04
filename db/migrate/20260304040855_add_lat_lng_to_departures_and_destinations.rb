# frozen_string_literal: true

class AddLatLngToDeparturesAndDestinations < ActiveRecord::Migration[7.2]
  def change
    add_column :departures, :latitude, :decimal, precision: 10, scale: 7
    add_column :departures, :longitude, :decimal, precision: 10, scale: 7
    add_column :destinations, :latitude, :decimal, precision: 10, scale: 7
    add_column :destinations, :longitude, :decimal, precision: 10, scale: 7
  end
end
