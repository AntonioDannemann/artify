class Monument < ApplicationRecord
  has_many :architect_monuments, dependent: :destroy
  has_many :architects, through: :architect_monuments
  has_many :histories, dependent: :destroy
  has_one_attached :photo

  reverse_geocoded_by :lat, :lng, address: :location
  after_validation :reverse_geocode

  validates :name, :description, :completion_date, :lat, :lng, :style, presence: true
  # validates :photo, presence: true
  validates :lat, :lng, numericality: { only_float: true }
end
