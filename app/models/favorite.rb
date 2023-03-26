class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :monument
  validates :user, :monument
end
