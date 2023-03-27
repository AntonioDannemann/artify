class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  before_save :track_completion

  def completed?
    status == "completed"
  end

  def progress!
    return if completed?

    case achievement.title
    when "Sprinter" then sprinter_progress
    when "Tourist" then tourist_progress
    else self.progress += 1
    end

    save
  end

  private

  def sprinter_progress
    self.progress = user.histories.count { |his| his.updated_at.today? }
  end

  def tourist_progress
    self.progress = user.histories.map(&:monument).group_by(&:country).count
  end

  def track_completion
    return unless progress == achievement.goal

    self.status = "completed"
    self.completion_date = Time.current
  end
end
