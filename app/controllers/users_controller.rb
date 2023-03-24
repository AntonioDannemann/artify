class UsersController < ApplicationController
  skip_after_action :verify_authorized

  def dashboard
    @user = current_user
    @histories = History.where(user: @user).order(created_at: :desc)
  end
end
