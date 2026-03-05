class ServiceType < ActiveHash::Base
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: '航空' },
    { id: 3, name: '船舶(LCL)' },
    { id: 4, name: '船舶(FCL)' },
    { id: 5, name: '鉄道' },
    { id: 6, name: '陸送' },
    { id: 7, name: '複合' }
  ]
  include ActiveHash::Associations
  has_many :providers
  has_many :services

  def self.selectable
    all.reject { |s| s.id == 1 }
  end
end
