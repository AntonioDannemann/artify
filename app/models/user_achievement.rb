class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  before_save :track_completion

  def completed?
    status == "completed"
  end

  # rubocop:disable Metrics/MethodLength
  def progress!
    return if completed?

    case achievement.title
    when "Get Going" then going_progress
    when "Curious One" then curious_one_progress
    when "Adventurer" then adventurer_progress
    when "King of the world" then king_progress
    when "Sprinter" then sprinter_progress
    when "Traveller" then traveller_progress
    else
      self.progress += 1
      save
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def track_completion
    return unless progress == achievement.goal

    self.status = "completed"
    self.completion_date = Time.current
  end

  def going_progress
    return unless user.user_achievements.joins(:achievement).find_by(achievement: { title: "Let's Begin" })&.completed?

    self.progress = self.progress.zero? ? 1 : self.progress + 1
    save
  end

  def curious_one_progress
    return unless user.user_achievements.joins(:achievement).find_by(achievement: { title: "Get Going" })&.completed?

    self.progress = self.progress.zero? ? 10 : self.progress + 1
    save
  end

  def adventurer_progress
    return unless user.user_achievements.joins(:achievement).find_by(achievement: { title: "Curious One" })&.completed?

    self.progress = self.progress.zero? ? 25 : self.progress + 1
    save
  end

  def king_progress
    return unless user.user_achievements.joins(:achievement).find_by(achievement: { title: "Adventurer" })&.completed?

    self.progress = self.progress.zero? ? 50 : self.progress + 1
    save
  end

  def sprinter_progress
    self.progress = user.histories.count { |his| his.updated_at.today? }
    save
  end

  def traveller_progress
    self.progress = user.histories.map(&:monument).group_by(&:country).count
    save
  end
end
