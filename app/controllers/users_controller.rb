class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @histories = @user.histories.order(updated_at: :desc)
    @achievements = @user.user_achievements.order("status DESC, updated_at DESC").first(5)
    @completed_achievements = []

    completed_achievements
  end

  private

  def completed_achievements
    @completed_achievements = []
    @user.user_achievements.each do |ach|
      @completed_achievements << ach if ach.completed?
    end
    @completed_achievements = @completed_achievements.last(3)
  end
end
