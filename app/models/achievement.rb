class Achievement < ApplicationRecord
  has_many :monument_achievements, dependent: :destroy
  has_many :user_achievements, dependent: :destroy
  has_many :users, through: :user_achievements
  has_one_attached :photo

  validates :photo, :title, :description, :goal, presence: true
  validates :goal, numericality: { only_integer: true }
end
