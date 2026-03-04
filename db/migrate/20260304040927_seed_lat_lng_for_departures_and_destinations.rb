# frozen_string_literal: true

class SeedLatLngForDeparturesAndDestinations < ActiveRecord::Migration[7.2]
  def up
    # 出発地（日本）：id 1 は指定なしのためスキップ
    { 2 => [35.68, 139.76], 3 => [35.44, 139.64], 4 => [35.18, 136.91], 5 => [34.69, 135.50],
      6 => [34.69, 135.19], 7 => [33.59, 130.40], 8 => [35.68, 139.76] }.each do |id, (lat, lng)|
      execute "UPDATE departures SET latitude = #{lat}, longitude = #{lng} WHERE id = #{id}"
    end
    # 到着地（世界の都市）
    { 2 => [34.05, -118.24], 3 => [40.71, -74.01], 4 => [51.51, -0.13], 5 => [52.37, 4.89],
      6 => [41.39, 2.17], 7 => [53.55, 9.99], 8 => [31.23, 121.47], 9 => [22.32, 114.17],
      10 => [35.10, 129.04], 11 => [10.82, 106.63], 12 => [5.42, 100.34], 13 => [13.76, 100.50],
      14 => [14.60, 120.98], 15 => [1.35, 103.82] }.each do |id, (lat, lng)|
      execute "UPDATE destinations SET latitude = #{lat}, longitude = #{lng} WHERE id = #{id}"
    end
  end

  def down
    execute "UPDATE departures SET latitude = NULL, longitude = NULL"
    execute "UPDATE destinations SET latitude = NULL, longitude = NULL"
  end
end
