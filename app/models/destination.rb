# frozen_string_literal: true

class Destination < ApplicationRecord
  has_many :services, dependent: :restrict_with_error

  validates :name, presence: true
  validates :position, presence: true, numericality: { only_integer: true }

  scope :selectable, -> { where.not(id: 1).order(:position) }
  scope :ordered, -> { order(:position) }
  scope :with_coordinates, -> { where.not(latitude: nil, longitude: nil) }
end
