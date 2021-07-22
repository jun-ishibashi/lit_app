class Departure < ActiveHash::Base
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: '東京' },
    { id: 3, name: '横浜' },
    { id: 4, name: '名古屋' },
    { id: 5, name: '大阪' },
    { id: 6, name: '神戸' },
    { id: 7, name: '博多' },
    { id: 8, name: 'その他' }
  ]
  include ActiveHash::Associations
  has_many :services
end
