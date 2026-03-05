module ApplicationHelper
  # 画面・メタで使うサービス名（config.x.app_display_name）
  def app_name
    Rails.application.config.x.app_display_name.presence || "CargoLink"
  end

  # 料金をカンマ区切り＋単位で表示（例: 30,000円）。通貨は PRICE_CURRENCY に準拠
  PRICE_CURRENCY = "JPY"
  PRICE_UNIT = "円"

  PRICE_TYPE_SUFFIX = {
    "total" => "",
    "per_kg" => "/kg",
    "per_cbm" => "/CBM",
    "per_container" => "" # 表示時に price_unit を使う（例: /20ft）
  }.freeze

  def format_price(price, suffix: nil)
    return "—" if price.blank?
    base = "#{number_with_delimiter(price.to_i)}#{PRICE_UNIT}"
    suffix.present? ? "#{base}#{suffix}" : base
  end

  # サービス登録の料金種別・単位に応じた表示（例: 30,000円、500円/kg、25,000円/20ft）
  def format_price_for_service(service)
    return "—" if service.blank? || service.price.blank?
    pt = service.price_type.presence || "total"
    suffix = case pt
             when "per_kg" then "/kg"
             when "per_cbm" then "/CBM"
             when "per_container" then service.price_unit.present? ? "/#{service.price_unit}" : ""
             else ""
             end
    format_price(service.price, suffix: suffix)
  end

  # 料金の単位・通貨の説明（表示用）
  def price_unit_description
    "日本円（#{PRICE_CURRENCY}）"
  end
end
