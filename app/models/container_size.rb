# frozen_string_literal: true

# コンテナサイズ（海上 FCL 用）
class ContainerSize < ActiveHash::Base
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: '20ft' },
    { id: 3, name: '40ft' }
  ]

  include ActiveHash::Associations
  has_many :services

  def self.selectable
    all.reject { |c| c.id == 1 }
  end
end
