class Service < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :provider
  belongs_to :departure
  belongs_to :destination
  belongs_to :service_type
  belongs_to :option
  belongs_to :service_scope

  validates :departure_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :destination_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :service_type_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :option_id, presence: true

  has_many :quote_requests, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at departure_id description destination_id id lead_time option_id price provider_id service_scope_id service_type_id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[departure destination option provider service_type]
  end
end
