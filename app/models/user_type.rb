class UserType < ActiveHash::Base
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: '法人' },
    { id: 3, name: '個人' }
  ]
  include ActiveHash::Associations
  has_many :users
end
