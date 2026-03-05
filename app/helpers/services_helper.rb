# frozen_string_literal: true

module ServicesHelper
  # 検索結果から「条件を変える」でトップに戻る際のクエリ（SearchParams と一元化）
  def search_refine_query_params
    raw_q = params[:q]
    q = raw_q.is_a?(ActionController::Parameters) ? raw_q.permit(::SearchParams::RANSACK_KEYS).to_h : (raw_q || {}).stringify_keys.slice(*::SearchParams::RANSACK_KEYS)
    out = {}
    out[:q] = q if q.present?
    ::SearchParams::EXTRA_KEYS.each { |k| out[k.to_sym] = params[k] if params[k].present? }
    out
  end

  # 検索条件のラベル表示用（1件だけ取り出して表示）
  def search_filter_label(key, value)
    return nil if value.blank?
    case key.to_s
    when "departure_id_eq" then Departure.find_by(id: value)&.name
    when "destination_id_eq" then Destination.find_by(id: value)&.name
    when "service_type_id_eq" then ServiceType.all.find { |s| s.id == value.to_i }&.name
    when "service_scope_id_eq" then ServiceScope.all.find { |s| s.id == value.to_i }&.name
    when "incoterm_id_eq" then Incoterm.all.find { |i| i.id == value.to_i }&.name
    when "container_size_id_eq" then ContainerSize.all.find { |c| c.id == value.to_i }&.name
    when "provider_id_eq" then Provider.find_by(id: value)&.name
    when "sorts"
      { "price asc" => "価格の安い順", "lead_time asc" => "リードタイムの短い順" }[value]
    else value.to_s
    end
  end

  # 貨物の目安のラベル
  def cargo_volume_label(value)
    { "small" => "少量", "medium" => "中量", "large" => "大量" }[value.to_s]
  end

  # 検索条件キーの日本語ラベル
  def search_filter_key_label(key)
    {
      "departure_id_eq" => "出発地",
      "destination_id_eq" => "到着地",
      "service_type_id_eq" => "サービスタイプ",
      "service_scope_id_eq" => "作業範囲",
      "incoterm_id_eq" => "インコタームズ",
      "container_size_id_eq" => "コンテナサイズ",
      "provider_id_eq" => "業者",
      "sorts" => "並び順"
    }[key.to_s] || key.to_s.humanize
  end
end
