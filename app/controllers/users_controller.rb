class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @histories = @user.histories.order(updated_at: :desc)
    @achievements = @user.user_achievements.order("status DESC, updated_at DESC").first(5)
  end
end
