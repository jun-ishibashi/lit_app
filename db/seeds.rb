# モック・テストデータ（開発・デモ用）
# 実行: bundle exec rails db:seed

puts 'Seeding...'

# 既存データがある場合はスキップ（再実行時用）
if User.exists? && Provider.exists?
  puts 'Users and Providers already exist. Run rails db:reset to clear and reseed.'
  exit
end

# --- ユーザー（輸送を依頼する側：法人・個人）---
users = [
  { name: 'テストユーザー', email: 'user@example.com', password: 'password', user_type_id: 2, product_id: 2, introduction: '生活雑貨の輸出を検討中です。' },
  { name: '山田太郎', email: 'yamada@example.com', password: 'password', user_type_id: 3, product_id: 3, introduction: '個人で食品を海外に送りたいです。' },
  { name: '株式会社サンプル', email: 'sample@example.com', password: 'password', user_type_id: 2, product_id: 7, introduction: '機械部品の輸出を主にしています。' }
]
users.each do |attr|
  User.find_or_create_by!(email: attr[:email]) do |u|
    u.name = attr[:name]
    u.password = attr[:password]
    u.password_confirmation = attr[:password]
    u.user_type_id = attr[:user_type_id]
    u.product_id = attr[:product_id]
    u.introduction = attr[:introduction]
  end
end
puts "Created #{User.count} users."

# --- プロバイダー（運送業者）---
providers_data = [
  { name: 'グローバル航空物流', email: 'provider@example.com', password: 'password', service_type_id: 2, introduction: '航空便を中心に国際輸送を提供しています。' },
  { name: 'オーシャン shipping', email: 'ocean@example.com', password: 'password', service_type_id: 3, introduction: 'LCL・FCL 両方対応。アジア・欧州ルートに強みがあります。' },
  { name: 'フェニックス海運', email: 'phoenix@example.com', password: 'password', service_type_id: 4, introduction: 'FCL コンテナ輸送が専門です。' }
]
providers_data.each do |attr|
  Provider.find_or_create_by!(email: attr[:email]) do |p|
    p.name = attr[:name]
    p.password = attr[:password]
    p.password_confirmation = attr[:password]
    p.service_type_id = attr[:service_type_id]
    p.introduction = attr[:introduction]
  end
end
providers = Provider.all.to_a
puts "Created #{providers.size} providers."

# --- サービス（各プロバイダーが提供するルート・料金）---
# departure_id: 2=東京,3=横浜,4=名古屋,5=大阪,6=神戸,7=博多
# destination_id: 2=LA,3=NY,4=London,8=Shanghai,9=Hong Kong,13=Bangkok,15=Singapore
# service_type_id: 2=航空,3=船舶LCL,4=船舶FCL
# option_id: 1=通常品,2=危険品,3=要冷蔵
services_data = [
  # グローバル航空物流（航空）
  { provider: providers[0], departure_id: 2, destination_id: 2, service_type_id: 2, price: 45_000, lead_time: 5, option_id: 1, description: '東京ーLA 航空便。通常品。' },
  { provider: providers[0], departure_id: 2, destination_id: 3, service_type_id: 2, price: 52_000, lead_time: 6, option_id: 1, description: '東京ーNY 航空便。' },
  { provider: providers[0], departure_id: 5, destination_id: 8, service_type_id: 2, price: 28_000, lead_time: 4, option_id: 1, description: '大阪ー上海 航空便。' },
  # オーシャン shipping（LCL）
  { provider: providers[1], departure_id: 2, destination_id: 2, service_type_id: 3, price: 18_000, lead_time: 21, option_id: 1, description: '東京ーLA LCL。コスト重視向け。' },
  { provider: providers[1], departure_id: 3, destination_id: 4, service_type_id: 3, price: 22_000, lead_time: 28, option_id: 1, description: '横浜ーロンドン LCL。' },
  { provider: providers[1], departure_id: 5, destination_id: 15, service_type_id: 3, price: 12_000, lead_time: 14, option_id: 1, description: '大阪ーシンガポール LCL。' },
  { provider: providers[1], departure_id: 6, destination_id: 13, service_type_id: 3, price: 15_000, lead_time: 12, option_id: 3, description: '神戸ーバンコク LCL。要冷蔵対応。' },
  # フェニックス海運（FCL）
  { provider: providers[2], departure_id: 2, destination_id: 2, service_type_id: 4, price: 350_000, lead_time: 18, option_id: 1, description: '東京ーLA 20ft FCL。' },
  { provider: providers[2], departure_id: 5, destination_id: 9, service_type_id: 4, price: 280_000, lead_time: 10, option_id: 1, description: '大阪ー香港 FCL。' },
  { provider: providers[2], departure_id: 7, destination_id: 11, service_type_id: 4, price: 120_000, lead_time: 5, option_id: 1, description: '博多ー釜山 FCL。近距離。' }
]

if Service.none?
  services_data.each do |attr|
    provider = attr.delete(:provider)
    Service.create!(attr.merge(provider_id: provider.id))
  end
  puts "Created #{Service.count} services."
else
  puts "Services already exist (#{Service.count} records)."
end

puts 'Done. Login examples:'
puts '  User:     user@example.com / password'
puts '  Provider: provider@example.com / password'
