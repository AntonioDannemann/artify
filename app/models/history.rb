class History < ApplicationRecord
  belongs_to :user
  belongs_to :monument
  has_one_attached :photo

  validates :photo, presence: true
end
