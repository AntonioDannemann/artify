class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  before_save :track_completion

  def completed?
    status == "completed"
  end

  def progress!
    self.progress += 1
  end

  private

  def track_completion
    return unless progress == achievement.goal

    self.status = "completed"
    self.completion_date = Time.current
  end
end
