class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @histories = @user.histories.order(updated_at: :desc)
    @favourite_monuments = @user.favourite_monuments.order(updated_at: :desc)
  end
end
