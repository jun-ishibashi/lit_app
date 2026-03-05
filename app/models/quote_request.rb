class QuoteRequest < ApplicationRecord
  belongs_to :user
  belongs_to :service
  belongs_to :incoterm, optional: true

  validates :status, inclusion: { in: %w[pending replied closed] }

  scope :pending, -> { where(status: "pending") }
  scope :recent, -> { order(created_at: :desc) }
end
