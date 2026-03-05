class Service < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :provider
  belongs_to :departure
  belongs_to :destination
  belongs_to :service_type
  belongs_to :option
  belongs_to :service_scope
  belongs_to :incoterm, optional: true
  belongs_to :container_size, optional: true

  PRICE_TYPES = %w[total per_kg per_cbm per_container].freeze

  validates :price_type, inclusion: { in: PRICE_TYPES }
  validates :departure_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :destination_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :service_type_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :option_id, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :lead_time, presence: true, numericality: { only_integer: true, greater_than: 0 }

  has_many :quote_requests, dependent: :destroy

  scope :with_list_associations, -> { includes(:departure, :destination, :provider) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at departure_id description destination_id id lead_time option_id price provider_id
       service_scope_id service_type_id updated_at incoterm_id container_size_id price_type price_includes]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[departure destination option provider service_type incoterm container_size]
  end
end
