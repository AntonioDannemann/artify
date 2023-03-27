class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @histories = @user.histories.order(updated_at: :desc)
  end
end
