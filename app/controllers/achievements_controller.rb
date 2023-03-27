class AchievementsController < ApplicationController
  def index
    @user = current_user
    @achievements = @user.user_achievements.order("status DESC, updated_at DESC")
  end
end
