class UsersController < ApplicationController
  skip_after_action :verify_authorized

  def dashboard
    @user = current_user
    @history = History.new
    @monuments = Monument.all

    @show_footer = true
  end
end
