class AchievementsController < ApplicationController
  def index
    @user = current_user
    @user_achievements = @user.user_achievements.order("status DESC, updated_at DESC")
    @achievements = Achievement.all - @user.user_achievements.map(&:achievement)
  end
end
