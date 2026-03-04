class Inquiry < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, length: { maximum: 200 }
  validates :message, presence: true, length: { maximum: 2000 }
end
