class Monument < ApplicationRecord
  has_many :histories, dependent: :destroy
  has_one_attached :photo

  reverse_geocoded_by :lat, :lng, address: :location
  after_validation :reverse_geocode

  validates :name, :description, :lat, :lng, :city, :country, :country_code, :photo, presence: true
  validates :lat, :lng, numericality: { only_float: true }
end
