class UsersController < ApplicationController
  skip_after_action :verify_authorized

  def dashboard
    @user = current_user
    @histories = History.where(user: @user).order(updated_at: :desc)
    @achievements = @user.user_achievements.order("status DESC, updated_at DESC").first(5)
  end
end
