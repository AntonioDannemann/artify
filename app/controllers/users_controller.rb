class UsersController < ApplicationController
  skip_after_action :verify_authorized

  def dashboard
    @user = current_user
    @histories = History.where(user: current_user)

    @histories = @histories.reverse
  end
end
