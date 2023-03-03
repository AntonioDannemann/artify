class Monument < ApplicationRecord
  validates :name, :description, :completion_date, :lat, :lng, :location, :style, presence: true
  validates :lat, :lng, numericality: { only_float: true }
end
