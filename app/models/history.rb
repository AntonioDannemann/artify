class History < ApplicationRecord
  belongs_to :user
  belongs_to :monument
  has_one_attached :photo

  validates :photo, :description, :lat, :lng, presence: true
  validates :lat, :lng, numericality: { only_float: true }
end
