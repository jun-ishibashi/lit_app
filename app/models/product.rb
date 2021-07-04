class Product < ActiveHash::Base
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: '生活雑貨' },
    { id: 3, name: '食品' },
    { id: 4, name: '石油製品' },
    { id: 5, name: '鉄鋼・鉱物性生産品' },
    { id: 6, name: '半導体' },
    { id: 7, name: '機械・機械部品' },
    { id: 8, name: '家具・インテリア' },
    { id: 9, name: 'アパレル製品' },
    { id: 10, name: '木材パルプ' },
    { id: 11, name: '乗用車' },
    { id: 12, name: '化学製品' },
    { id: 13, name: 'その他' }

  ]
  include ActiveHash::Associations
  has_many :users
end
