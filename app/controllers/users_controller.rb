class UsersController < ApplicationController
  def dashboard
    @user = current_user

    @histories = @user.histories.order(updated_at: :desc)
    @favourite_monuments = current_user.favourites.order(created_at: :desc).map(&:monument)
  end
end
