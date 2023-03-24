class MonumentAchievement < ApplicationRecord
  belongs_to :achievement
  belongs_to :monument
end
