class Service < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :departure
  belongs_to :destination
  belongs_to :service_type
  belongs_to :option, optional: true

  validates :departure_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :destination_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :service_type_id, numericality: { other_than: 1, message: "can't be blank" }

  belongs_to :provider
end
