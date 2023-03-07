require 'open-uri'

class HistoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show create]

  def show
    @history = History.find(params[:id])
  end

  def create
    @photo = params[:history][:photo]
    @user = current_user || User.find_by(first_name: "guest")
    redirect_to root_path
  end
end
