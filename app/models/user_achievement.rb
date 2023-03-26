class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  before_save :track_completion

  def completed?
    status == "completed"
  end

  def progress!
    return if completed?

    self.progress += 1
    save
  end

  private

  def track_completion
    return unless progress == achievement.goal

    self.status = "completed"
    self.completion_date = Time.current
  end
end
