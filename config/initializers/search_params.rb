# frozen_string_literal: true

# 検索パラメータの一元定義。トップの検索フォーム・ステップ検索・検索結果の「条件を変える」で共通利用
module SearchParams
  RANSACK_KEYS = %w[
    departure_id_eq
    destination_id_eq
    service_type_id_eq
    provider_id_eq
    sorts
  ].freeze

  EXTRA_KEYS = %w[shipping_date arrival_date cargo_volume].freeze
end
