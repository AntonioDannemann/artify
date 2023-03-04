class Monument < ApplicationRecord
  has_many :architect_monuments, dependent: :destroy
  has_one_attached :photo

  validates :name, :description, :completion_date, :lat, :lng, :location, :style, :photo, presence: true
  validates :lat, :lng, numericality: { only_float: true }
end
