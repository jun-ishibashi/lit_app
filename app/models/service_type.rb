class ServiceType < ActiveHash::Base
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: '航空' },
    { id: 3, name: '船舶(LCL)' },
    { id: 4, name: '船舶(FCL)' }
  ]
  include ActiveHash::Associations
  has_many :providers
  has_many :services
end
