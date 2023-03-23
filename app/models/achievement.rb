class Achievement < ApplicationRecord
  has_one_attached :locked
  has_one_attached :unlocked

  validates :locked, :unlocked, :title, :description, :goal, presence: true
  validates :goal, numericality: { only_integer: true }
end
