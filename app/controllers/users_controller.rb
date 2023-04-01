class UsersController < ApplicationController
  def dashboard
    @user = current_user

    @histories = @user.histories.order(updated_at: :desc)
    @favourite_monuments = current_user.favourites.order(created_at: :desc).map(&:monument)
    @achievements = @user.user_achievements.order("status DESC, updated_at DESC").first(5)
    @completed_achievements = @user.user_achievements.select(&:completed?).last(3).map(&:achievement).reverse
  end
end
