class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :user_type
  belongs_to :product

  validates :user_type_id, numericality: { other_than: 1 }
  validates :product_id, numericality: { other_than: 1 }
end
