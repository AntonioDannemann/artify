class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @histories = @user.histories.order(updated_at: :desc)
    @user_achievements = @user.user_achievements.order("status DESC, updated_at DESC").first(4)
  end
end
