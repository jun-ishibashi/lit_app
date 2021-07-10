class Destination < ActiveHash::Base
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: 'Los Angeles' },
    { id: 3, name: 'New York' },
    { id: 4, name: 'London' },
    { id: 5, name: 'Amsterdam' },
    { id: 6, name: 'Barselona' },
    { id: 7, name: 'Hamburg' },
    { id: 8, name: 'Shanghai' },
    { id: 9, name: 'Hong kong' },
    { id: 10, name: 'Busan' },
    { id: 11, name: 'Ho Chi Minh' },
    { id: 12, name: 'Penan' },
    { id: 13, name: 'Bangkok' },
    { id: 14, name: 'Manila' },
    { id: 15, name: 'Singapore' },
  ]
  include ActiveHash::Associations
  has_many :services
end