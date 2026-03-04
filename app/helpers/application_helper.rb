module ApplicationHelper
  # 料金をカンマ区切り＋「円」で表示（例: 30,000円）
  def format_price(price)
    return "—" if price.blank?
    "#{number_with_delimiter(price.to_i)}円"
  end
end
