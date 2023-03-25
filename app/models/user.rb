class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :histories, dependent: :destroy
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements
  has_one_attached :photo

  validates :first_name, :last_name, presence: true

  def self.destroy_guests
    User.destroy_by(first_name: "guest", last_name: nil)
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def update_achievements(achievements)
    achievements.each_with_object([]) do |achievement, new_completions|
      user_achievement = UserAchievement.find_or_initialize_by(user: self, achievement:)
      next if user_achievement.completed? && !user_achievement.new_record?

      user_achievement.progress!
      new_completions << user_achievement if user_achievement.completed?
    end
  end
end
