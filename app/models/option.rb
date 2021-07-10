class Option < ActiveHash::Base
  self.data = [
    { id: 1, name: '通常品' },
    { id: 2, name: '危険品' },
    { id: 3, name: '要冷蔵' },
    { id: 4, name: '要冷凍' },
    { id: 5, name: 'その他' },
  ]
  include ActiveHash::Associations
  has_many :services
end